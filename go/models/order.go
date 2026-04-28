package models

import "gorm.io/gorm"

type Order struct {
	gorm.Model
	UserID      uint        `gorm:"not null;index"       json:"user_id"`
	User        User        `gorm:"foreignKey:UserID"    json:"user,omitempty"`
	OrderNumber string      `gorm:"size:50;uniqueIndex"  json:"order_number"`
	Status      string      `gorm:"size:20;default:pending" json:"status"`
	TotalAmount float64     `gorm:"not null"             json:"total_amount"`
	Items       []OrderItem `gorm:"foreignKey:OrderID"   json:"items,omitempty"`
	Notes       string      `gorm:"type:text"            json:"notes"`
}

type OrderItem struct {
	gorm.Model
	OrderID   uint    `gorm:"not null;index"       json:"order_id"`
	ProductID uint    `gorm:"not null;index"       json:"product_id"`
	Product   Product `gorm:"foreignKey:ProductID" json:"product,omitempty"`
	Quantity  int     `gorm:"not null"             json:"quantity"`
	Price     float64 `gorm:"not null"             json:"price"`
}

type CreateOrderRequest struct {
	Notes string `json:"notes"`
}