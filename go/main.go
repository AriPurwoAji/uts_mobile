package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/v1/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "API jalan",
		})
	})

	r.Run(":8080")
	r.GET("/v1/test-auth", func(c *gin.Context) {
	token := c.GetHeader("Authorization")

	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": "no token",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "token diterima",
		"token": token,
	})
})
}