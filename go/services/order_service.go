package services

import (
	"errors"
	"fmt"
	"time"

	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/repositories"
)

type OrderService struct {
	orderRepo *repositories.OrderRepository
	cartRepo  *repositories.CartRepository
}

func NewOrderService() *OrderService {
	return &OrderService{
		orderRepo: repositories.NewOrderRepository(),
		cartRepo:  repositories.NewCartRepository(),
	}
}

func (s *OrderService) CreateFromCart(userID uint, req *models.CreateOrderRequest) (*models.Order, error) {
	cart, err := s.cartRepo.FindByUserID(userID)
	if err != nil || len(cart.Items) == 0 {
		return nil, errors.New("cart kosong")
	}

	// Hitung total
	var total float64
	var orderItems []models.OrderItem
	for _, item := range cart.Items {
		total += item.Price * float64(item.Quantity)
		orderItems = append(orderItems, models.OrderItem{
			ProductID: item.ProductID,
			Quantity:  item.Quantity,
			Price:     item.Price,
		})
	}

	order := &models.Order{
		UserID:      userID,
		OrderNumber: fmt.Sprintf("HL-%d-%d", userID, time.Now().Unix()),
		Status:      "pending",
		TotalAmount: total,
		Items:       orderItems,
		Notes:       req.Notes,
	}

	err = s.orderRepo.Create(order)
	return order, err
}

func (s *OrderService) GetUserOrders(userID uint) ([]models.Order, error) {
	return s.orderRepo.FindByUserID(userID)
}

func (s *OrderService) GetOrderByID(id uint) (*models.Order, error) {
	return s.orderRepo.FindByID(id)
}