package models

import "gorm.io/gorm"

type Product struct {
	gorm.Model
	Name        string  `gorm:"size:200;not null;index" json:"name"`
	Description string  `gorm:"type:text"              json:"description"`
	Price       float64 `gorm:"not null"               json:"price"`
	Stock       int     `gorm:"default:0"              json:"stock"`
	CategoryID  uint    `gorm:"index"                  json:"category_id"`
	Category    Category `gorm:"foreignKey:CategoryID" json:"category,omitempty"`
	Brand       string  `gorm:"size:100"               json:"brand"`
	PartNumber  string  `gorm:"size:100;index"         json:"part_number"`
	ImageURL    string  `gorm:"size:500"               json:"image_url"`
	IsActive    bool    `gorm:"default:true;index"     json:"is_active"`

	// Spesifikasi khusus hydraulic
	FlowRate    string `gorm:"size:50"  json:"flow_rate"`
	MaxPressure string `gorm:"size:50"  json:"max_pressure"`
	MountType   string `gorm:"size:50"  json:"mount_type"`
	Condition   string `gorm:"size:20;default:New" json:"condition"`
	ShaftType   string `gorm:"size:50"  json:"shaft_type"`
	PortingType string `gorm:"size:50"  json:"porting_type"`

	// Relasi
	Images   []ProductImage `gorm:"foreignKey:ProductID" json:"images,omitempty"`
	Reviews  []Review       `gorm:"foreignKey:ProductID" json:"reviews,omitempty"`
}

type ProductImage struct {
	gorm.Model
	ProductID uint   `gorm:"not null;index" json:"product_id"`
	ImageURL  string `gorm:"size:500;not null" json:"image_url"`
	SortOrder int    `gorm:"default:0"      json:"sort_order"`
}

type Review struct {
	gorm.Model
	ProductID uint   `gorm:"not null;index" json:"product_id"`
	UserID    uint   `gorm:"not null;index" json:"user_id"`
	User      User   `gorm:"foreignKey:UserID" json:"user,omitempty"`
	Rating    int    `gorm:"not null"       json:"rating"`
	Comment   string `gorm:"type:text"      json:"comment"`
}

// DTOs
type CreateProductRequest struct {
	Name        string  `json:"name"         binding:"required,min=2,max=200"`
	Description string  `json:"description"`
	Price       float64 `json:"price"        binding:"required,gt=0"`
	Stock       int     `json:"stock"        binding:"min=0"`
	CategoryID  uint    `json:"category_id"  binding:"required"`
	Brand       string  `json:"brand"`
	PartNumber  string  `json:"part_number"`
	ImageURL    string  `json:"image_url"`
	FlowRate    string  `json:"flow_rate"`
	MaxPressure string  `json:"max_pressure"`
	MountType   string  `json:"mount_type"`
	Condition   string  `json:"condition"`
	ShaftType   string  `json:"shaft_type"`
	PortingType string  `json:"porting_type"`
}

type UpdateProductRequest struct {
	Name        *string  `json:"name"         binding:"omitempty,min=2"`
	Description *string  `json:"description"`
	Price       *float64 `json:"price"        binding:"omitempty,gt=0"`
	Stock       *int     `json:"stock"        binding:"omitempty,min=0"`
	CategoryID  *uint    `json:"category_id"`
	Brand       *string  `json:"brand"`
	PartNumber  *string  `json:"part_number"`
	ImageURL    *string  `json:"image_url"`
	FlowRate    *string  `json:"flow_rate"`
	MaxPressure *string  `json:"max_pressure"`
	MountType   *string  `json:"mount_type"`
	Condition   *string  `json:"condition"`
	ShaftType   *string  `json:"shaft_type"`
	PortingType *string  `json:"porting_type"`
}