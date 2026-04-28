package services

import (
	"errors"

	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/repositories"
	"gorm.io/gorm"
)

type CartService struct {
	cartRepo    *repositories.CartRepository
	productRepo *repositories.ProductRepository
}

func NewCartService() *CartService {
	return &CartService{
		cartRepo:    repositories.NewCartRepository(),
		productRepo: repositories.NewProductRepository(),
	}
}

func (s *CartService) GetCart(userID uint) (*models.Cart, error) {
	cart, err := s.cartRepo.FindByUserID(userID)
	if errors.Is(err, gorm.ErrRecordNotFound) {
		// Buat cart baru jika belum ada
		cart = &models.Cart{UserID: userID}
		if err := s.cartRepo.CreateCart(cart); err != nil {
			return nil, err
		}
	} else if err != nil {
		return nil, err
	}
	return cart, nil
}

func (s *CartService) AddItem(userID uint, req *models.AddToCartRequest) (*models.Cart, error) {
	// Cek produk ada dan stok cukup
	product, err := s.productRepo.FindByID(req.ProductID)
	if err != nil {
		return nil, errors.New("produk tidak ditemukan")
	}
	if product.Stock < req.Quantity {
		return nil, errors.New("stok tidak cukup")
	}

	cart, err := s.GetCart(userID)
	if err != nil {
		return nil, err
	}

	// Cek apakah produk sudah ada di cart
	existingItem, err := s.cartRepo.FindCartItem(cart.ID, req.ProductID)
	if err == nil {
		// Update quantity
		existingItem.Quantity += req.Quantity
		s.cartRepo.UpdateItem(existingItem)
	} else {
		// Tambah item baru
		item := &models.CartItem{
			CartID:    cart.ID,
			ProductID: req.ProductID,
			Quantity:  req.Quantity,
			Price:     product.Price,
		}
		s.cartRepo.AddItem(item)
	}

	return s.cartRepo.FindByUserID(userID)
}

func (s *CartService) RemoveItem(userID, itemID uint) error {
	cart, err := s.GetCart(userID)
	if err != nil {
		return err
	}
	return s.cartRepo.DeleteItem(cart.ID, itemID)
}