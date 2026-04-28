package models

import "gorm.io/gorm"

type Category struct {
	gorm.Model
	Name     string    `gorm:"size:100;not null;uniqueIndex" json:"name"`
	Slug     string    `gorm:"size:100;not null;uniqueIndex" json:"slug"`
	IconURL  string    `gorm:"size:500"                     json:"icon_url"`
	Products []Product `gorm:"foreignKey:CategoryID"        json:"products,omitempty"`
}

type CreateCategoryRequest struct {
	Name    string `json:"name"     binding:"required"`
	Slug    string `json:"slug"     binding:"required"`
	IconURL string `json:"icon_url"`
}