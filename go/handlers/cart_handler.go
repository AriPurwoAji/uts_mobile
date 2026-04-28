package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/services"
)

type CartHandler struct {
	cartService *services.CartService
}

func NewCartHandler() *CartHandler {
	return &CartHandler{cartService: services.NewCartService()}
}

func (h *CartHandler) GetCart(c *gin.Context) {
	userID := uint(c.GetFloat64("user_id"))
	cart, err := h.cartService.GetCart(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": "Gagal mengambil cart"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": cart})
}

func (h *CartHandler) AddItem(c *gin.Context) {
	userID := uint(c.GetFloat64("user_id"))
	var req models.AddToCartRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	cart, err := h.cartService.AddItem(userID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Produk ditambahkan ke cart", "data": cart})
}

func (h *CartHandler) RemoveItem(c *gin.Context) {
	userID := uint(c.GetFloat64("user_id"))
	itemID, err := strconv.ParseUint(c.Param("itemId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "ID tidak valid"})
		return
	}
	if err := h.cartService.RemoveItem(userID, uint(itemID)); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Item dihapus dari cart"})
}