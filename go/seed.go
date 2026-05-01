//go:build ignore
// +build ignore

package main

import (
	"log"

	"github.com/joho/godotenv"
	"github.com/AriPurwoAji/go/config"
	"github.com/AriPurwoAji/go/models"
)

func main() {
	if err := godotenv.Load(".env"); err != nil {
		log.Println("File .env tidak ditemukan")
	}

	config.InitDatabase()
	log.Println("Mulai seeding...")

	// Seed Categories
	categories := []models.Category{
		{Name: "Pumps",       Slug: "pumps"},
		{Name: "Valves",      Slug: "valves"},
		{Name: "Cylinders",   Slug: "cylinders"},
		{Name: "Hoses",       Slug: "hoses"},
		{Name: "Fittings",    Slug: "fittings"},
		{Name: "Accessories", Slug: "accessories"},
	}
	for _, c := range categories {
		config.DB.Where("slug = ?", c.Slug).FirstOrCreate(&c)
		log.Printf("Kategori OK: %s", c.Name)
	}

	// Ambil ID kategori
	var catPumps, catValves, catCylinders, catHoses models.Category
	config.DB.Where("slug = ?", "pumps").First(&catPumps)
	config.DB.Where("slug = ?", "valves").First(&catValves)
	config.DB.Where("slug = ?", "cylinders").First(&catCylinders)
	config.DB.Where("slug = ?", "hoses").First(&catHoses)

	// Seed Products
	products := []models.Product{
		{
			Name: "Piston Pump PGH4 - High Pressure",
			Description: "High pressure axial piston pump",
			Price: 1250.00, Stock: 10,
			CategoryID: catPumps.ID, Brand: "Bosch Rexroth",
			PartNumber: "PGH4-2X/040", IsActive: true,
			FlowRate: "45 L/min", MaxPressure: "350 bar",
			MountType: "SAE B", Condition: "New",
			ShaftType: "Splined", PortingType: "Side",
		},
		{
			Name: "Directional Valve D1VW",
			Description: "Hydraulic directional control valve",
			Price: 310.00, Stock: 25,
			CategoryID: catValves.ID, Brand: "Vickers",
			PartNumber: "D1VW020CNYW", IsActive: true,
			FlowRate: "60 L/min", MaxPressure: "250 bar",
			MountType: "CETOP 3", Condition: "New",
			ShaftType: "-", PortingType: "Side",
		},
		{
			Name: "Hydraulic Cylinder HC100",
			Description: "Double acting hydraulic cylinder",
			Price: 580.00, Stock: 15,
			CategoryID: catCylinders.ID, Brand: "Parker",
			PartNumber: "HC100-50-300", IsActive: true,
			FlowRate: "-", MaxPressure: "200 bar",
			MountType: "Flange", Condition: "New",
			ShaftType: "-", PortingType: "-",
		},
		{
			Name: "High Pressure Hose HP12",
			Description: "Wire braided hydraulic hose 1 meter",
			Price: 45.00, Stock: 100,
			CategoryID: catHoses.ID, Brand: "Gates",
			PartNumber: "HP12-1M", IsActive: true,
			FlowRate: "-", MaxPressure: "420 bar",
			MountType: "-", Condition: "New",
			ShaftType: "-", PortingType: "-",
		},
	}
	for _, p := range products {
		config.DB.Where("part_number = ?", p.PartNumber).FirstOrCreate(&p)
		log.Printf("Produk OK: %s", p.Name)
	}

	log.Println("Seeding selesai!")
}