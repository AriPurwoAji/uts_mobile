package main

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/routes"
)

func main() {
	// 1. Load .env file
	if err := godotenv.Load(); err != nil {
		log.Println("File .env tidak ditemukan, menggunakan environment variable sistem")
	}

	// 2. Init Firebase
	config.InitFirebase()

	// 3. Init Database + AutoMigrate
	config.InitDatabase()

	// 4. Setup Router
	router := routes.SetupRouter()

	// 5. Jalankan server
	port := os.Getenv("APP_PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server berjalan di http://localhost:%s", port)
	log.Printf("Health check: http://localhost:%s/v1/health", port)

	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Gagal menjalankan server: %v", err)
	}
}