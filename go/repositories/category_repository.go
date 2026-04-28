package repositories

import (
	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
)

type CategoryRepository struct{}

func NewCategoryRepository() *CategoryRepository {
	return &CategoryRepository{}
}

func (r *CategoryRepository) FindAll() ([]models.Category, error) {
	var categories []models.Category
	result := config.DB.Find(&categories)
	return categories, result.Error
}

func (r *CategoryRepository) FindByID(id uint) (*models.Category, error) {
	var category models.Category
	result := config.DB.First(&category, id)
	return &category, result.Error
}

func (r *CategoryRepository) Create(category *models.Category) error {
	return config.DB.Create(category).Error
}