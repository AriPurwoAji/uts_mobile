package services

import (
	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/repositories"
)

type CategoryService struct {
	categoryRepo *repositories.CategoryRepository
}

func NewCategoryService() *CategoryService {
	return &CategoryService{categoryRepo: repositories.NewCategoryRepository()}
}

func (s *CategoryService) GetAll() ([]models.Category, error) {
	return s.categoryRepo.FindAll()
}

func (s *CategoryService) Create(req *models.CreateCategoryRequest) (*models.Category, error) {
	category := &models.Category{
		Name:    req.Name,
		Slug:    req.Slug,
		IconURL: req.IconURL,
	}
	err := s.categoryRepo.Create(category)
	return category, err
}