package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/AriPurwoAji/gin-firebase-backend/handlers"
	"github.com/AriPurwoAji/gin-firebase-backend/middleware"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Init handlers
	authHandler     := handlers.NewAuthHandler()
	productHandler  := handlers.NewProductHandler()
	categoryHandler := handlers.NewCategoryHandler()
	cartHandler     := handlers.NewCartHandler()
	orderHandler    := handlers.NewOrderHandler()

	v1 := r.Group("/v1")
	{
		v1.GET("/health", func(c *gin.Context) {
			c.JSON(200, gin.H{"status": "ok", "service": "hydrau-link-be"})
		})

		// Auth (public)
		auth := v1.Group("/auth")
		{
			auth.POST("/verify-token", authHandler.VerifyToken)
		}

		// Categories (public)
		v1.GET("/categories", categoryHandler.GetAll)

		// Products (public)
		v1.GET("/products", productHandler.GetAll)
		v1.GET("/products/:id", productHandler.GetByID)

		// Protected routes
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware())
		{
			// Cart
			cart := protected.Group("/cart")
			{
				cart.GET("", cartHandler.GetCart)
				cart.POST("/items", cartHandler.AddItem)
				cart.DELETE("/items/:itemId", cartHandler.RemoveItem)
			}

			// Orders
			orders := protected.Group("/orders")
			{
				orders.POST("", orderHandler.CreateOrder)
				orders.GET("", orderHandler.GetMyOrders)
			}

			// Admin only
			admin := protected.Group("")
			admin.Use(middleware.AdminOnly())
			{
				admin.POST("/categories", categoryHandler.Create)
				admin.POST("/products", productHandler.Create)
				admin.PUT("/products/:id", productHandler.Update)
				admin.DELETE("/products/:id", productHandler.Delete)
			}
		}
	}

	return r
}