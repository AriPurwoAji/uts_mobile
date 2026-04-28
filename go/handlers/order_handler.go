package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/services"
)

type OrderHandler struct {
	orderService *services.OrderService
}

func NewOrderHandler() *OrderHandler {
	return &OrderHandler{orderService: services.NewOrderService()}
}

func (h *OrderHandler) CreateOrder(c *gin.Context) {
	userID := uint(c.GetFloat64("user_id"))
	var req models.CreateOrderRequest
	c.ShouldBindJSON(&req)

	order, err := h.orderService.CreateFromCart(userID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Order berhasil dibuat", "data": order})
}

func (h *OrderHandler) GetMyOrders(c *gin.Context) {
	userID := uint(c.GetFloat64("user_id"))
	orders, err := h.orderService.GetUserOrders(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": "Gagal mengambil order"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": orders})
}