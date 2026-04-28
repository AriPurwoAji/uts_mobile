package repositories

import (
	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
)

type CartRepository struct{}

func NewCartRepository() *CartRepository {
	return &CartRepository{}
}

func (r *CartRepository) FindByUserID(userID uint) (*models.Cart, error) {
	var cart models.Cart
	result := config.DB.
		Preload("Items.Product").
		Where("user_id = ?", userID).
		First(&cart)
	if result.Error != nil {
		return nil, result.Error
	}
	return &cart, nil
}

func (r *CartRepository) CreateCart(cart *models.Cart) error {
	return config.DB.Create(cart).Error
}

func (r *CartRepository) FindCartItem(cartID, productID uint) (*models.CartItem, error) {
	var item models.CartItem
	result := config.DB.
		Where("cart_id = ? AND product_id = ?", cartID, productID).
		First(&item)
	return &item, result.Error
}

func (r *CartRepository) AddItem(item *models.CartItem) error {
	return config.DB.Create(item).Error
}

func (r *CartRepository) UpdateItem(item *models.CartItem) error {
	return config.DB.Save(item).Error
}

func (r *CartRepository) DeleteItem(cartID, itemID uint) error {
	return config.DB.
		Where("id = ? AND cart_id = ?", itemID, cartID).
		Delete(&models.CartItem{}).Error
}