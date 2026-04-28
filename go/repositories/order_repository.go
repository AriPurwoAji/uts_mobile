package repositories

import (
	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
)

type OrderRepository struct{}

func NewOrderRepository() *OrderRepository {
	return &OrderRepository{}
}

func (r *OrderRepository) FindByUserID(userID uint) ([]models.Order, error) {
	var orders []models.Order
	result := config.DB.
		Preload("Items.Product").
		Where("user_id = ?", userID).
		Order("created_at DESC").
		Find(&orders)
	return orders, result.Error
}

func (r *OrderRepository) FindByID(id uint) (*models.Order, error) {
	var order models.Order
	result := config.DB.
		Preload("Items.Product").
		First(&order, id)
	return &order, result.Error
}

func (r *OrderRepository) Create(order *models.Order) error {
	return config.DB.Create(order).Error
}