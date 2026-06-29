package main

import (
	"log"

	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	config.InitDatabase()

	// Seed Categories
	categories := []models.Category{
		{Name: "Pumps",       Slug: "pumps"},
		{Name: "Valves",      Slug: "valves"},
		{Name: "Cylinders",   Slug: "cylinders"},
		{Name: "Hoses",       Slug: "hoses"},
		{Name: "Fittings",    Slug: "fittings"},
		{Name: "Accessories", Slug: "accessories"},
	}
	for _, p := range categories {
		config.DB.Create(&p)
	}

	// Seed Products
	var catPumps, catValves, catCylinders, catHoses models.Category
	config.DB.Where("slug = ?", "pumps").First(&catPumps)
	config.DB.Where("slug = ?", "valves").First(&catValves)
	config.DB.Where("slug = ?", "cylinders").First(&catCylinders)
	config.DB.Where("slug = ?", "hoses").First(&catHoses)

	products := []models.Product{
		{
			Name:        "Piston Pump PGH4 - High Pressure",
			Price:       18500000,
			Stock:       10,
			CategoryID:  catPumps.ID,
			Brand:       "Bosch Rexroth",
			PartNumber:  "PGH4-2X/040",
			ImageURL:    "assets/images/pump.jpg",
			IsActive:    true,
			FlowRate:    "45 L/min",
			MaxPressure: "350 bar",
			MountType:   "SAE B",
			Condition:   "New",
			ShaftType:   "Splined",
			PortingType: "Side",
		},
		{
			Name:        "Directional Valve D1VW",
			Price:       4750000,
			Stock:       25,
			CategoryID:  catValves.ID,
			Brand:       "Vickers",
			PartNumber:  "D1VW020CNYW",
			ImageURL:    "assets/images/valve.jpg",
			IsActive:    true,
			FlowRate:    "60 L/min",
			MaxPressure: "250 bar",
			MountType:   "CETOP 3",
			Condition:   "New",
			ShaftType:   "-",
			PortingType: "Side",
		},
		{
			Name:        "Hydraulic Cylinder HC100",
			Price:       8200000,
			Stock:       15,
			CategoryID:  catCylinders.ID,
			Brand:       "Parker",
			PartNumber:  "HC100-50-300",
			ImageURL:    "assets/images/cylinder.jpg",
			IsActive:    true,
			FlowRate:    "-",
			MaxPressure: "200 bar",
			MountType:   "Flange",
			Condition:   "New",
			ShaftType:   "-",
			PortingType: "-",
		},
		{
			Name:        "High Pressure Hose HP12",
			Price:       350000,
			Stock:       100,
			CategoryID:  catHoses.ID,
			Brand:       "Gates",
			PartNumber:  "HP12-1M",
			ImageURL:    "assets/images/hose.jpg",
			IsActive:    true,
			FlowRate:    "-",
			MaxPressure: "420 bar",
			MountType:   "-",
			Condition:   "New",
			ShaftType:   "-",
			PortingType: "-",
		},
	}

	for _, p := range products {
		config.DB.Create(&p)
	}

	log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}