package models

import "gorm.io/gorm"

type Cart struct {
	gorm.Model
	UserID uint       `gorm:"not null;uniqueIndex" json:"user_id"`
	User   User       `gorm:"foreignKey:UserID"   json:"user,omitempty"`
	Items  []CartItem `gorm:"foreignKey:CartID"   json:"items,omitempty"`
}

type CartItem struct {
	gorm.Model
	CartID    uint    `gorm:"not null;index"        json:"cart_id"`
	ProductID uint    `gorm:"not null;index"        json:"product_id"`
	Product   Product `gorm:"foreignKey:ProductID"  json:"product,omitempty"`
	Quantity  int     `gorm:"not null;default:1"    json:"quantity"`
	Price     float64 `gorm:"not null"              json:"price"`
}

type AddToCartRequest struct {
	ProductID uint `json:"product_id" binding:"required"`
	Quantity  int  `json:"quantity"   binding:"required,min=1"`
}

type UpdateCartItemRequest struct {
	Quantity int `json:"quantity" binding:"required,min=1"`
}