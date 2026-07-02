# Hydrau-Link App — E-Commerce Hydraulic Store

Proyek e-commerce suku cadang hidrolik dengan frontend Flutter dan backend Golang.
Aplikasi ini menggunakan Firebase Authentication untuk login email & Google, mengelola cart dan order, serta mendukung pembayaran lewat deep link ke aplikasi E-Money.

## Identitas Mahasiswa

- Nama: Ari Purwo Aji
- NIM: 1123150126
- Kelas: TI 23 SE M
- Email: 1123150126@global.ac.id

## Repository Terkait

| Nama Repository | Lokasi / URL |
| --- | --- |
| Hydrau-Link App | `c:\androidlanjutan\uts` |
| Dompet Kampus Global (E-Money) | https://github.com/AriPurwoAji/dompet-kampus-global |

## Ringkasan Proyek

Hydrau-Link adalah aplikasi marketplace suku cadang hidrolik untuk kampus. Pengguna dapat:

- register dan login dengan Firebase Authentication
- login dengan Google Sign-In
- melihat kategori produk dan produk unggulan
- menambahkan produk ke cart
- checkout pesanan dengan pilihan pembayaran
- membuat order ke backend dan melihat riwayat pesanan
- melakukan pembayaran menggunakan aplikasi E-Money melalui deep link

## Arsitektur Aplikasi

Aplikasi ini dibangun dengan pemisahan frontend/backend:

- `hydraulicstore/` — Flutter app dengan Provider, Firebase Auth, Dio, dan url_launcher
- `go/` — backend Golang dengan Gin, GORM, MySQL, Firebase Admin, dan JWT

## Struktur Repository

```
uts/
├── go/                     # backend Golang
│   ├── config/
│   ├── handlers/
│   ├── middleware/
│   ├── models/
│   ├── repositories/
│   ├── routes/
│   ├── seed/
│   ├── firebase-service-account.json
│   ├── .env
│   └── main.go
├── hydraulicstore/         # frontend Flutter
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── assets/
│   ├── pubspec.yaml
│   └── firebase.json
└── README.md
```

## Fitur Utama

- Firebase Authentication email/password dan Google Sign-In
- Verifikasi email sebelum login
- Browsing kategori dan produk
- Keranjang belanja (cart)
- Checkout pesanan dan pembuatan order
- Pembayaran via deep link ke aplikasi E-Money
- Dukungan JWT untuk protected API

## Dependensi Utama

### Flutter

- `firebase_core` — inisialisasi Firebase
- `firebase_auth` — autentikasi Firebase
- `google_sign_in` — login Google
- `provider` — state management
- `dio` — HTTP client
- `flutter_secure_storage` — penyimpanan token aman
- `url_launcher` — membuka deep link E-Money

### Backend Go

- `gin-gonic/gin` — HTTP router
- `gorm.io/gorm` + `gorm.io/driver/mysql` — MySQL ORM
- `firebase.google.com/go/v4` — Firebase Admin SDK
- `github.com/golang-jwt/jwt/v5` — JWT auth
- `github.com/joho/godotenv` — load `.env`

## Cara Menjalankan Proyek

### 1. Jalankan Backend

```bash
cd go
go run main.go
```

Backend akan berjalan secara default di `http://localhost:8081`.

### 2. Jalankan Frontend Flutter

```bash
cd hydraulicstore
flutter pub get
flutter run
```

### Konfigurasi API Flutter

Ubah alamat backend di `hydraulicstore/lib/core/constants/api_constants.dart` jika diperlukan.
Contoh:

```dart
static const String baseUrl = 'http://192.168.1.22:8081/v1';
```

Untuk Android emulator, gunakan `10.0.2.2:8081` jika backend berjalan di mesin host.

## Konfigurasi Backend

File `go/.env` berisi variabel lingkungan penting:

- `APP_PORT`
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET`, `JWT_EXPIRE_HOURS`
- `FIREBASE_CREDENTIALS_PATH`

> Pastikan file `firebase-service-account.json` tidak dipublikasikan di repositori publik.

## API Backend Utama

- `POST /v1/auth/verify-token` — verifikasi Firebase token, terbitkan JWT
- `GET /v1/categories` — daftar kategori produk
- `GET /v1/products` — daftar produk
- `GET /v1/products/:id` — detail produk
- `GET /v1/cart` — ambil cart user
- `POST /v1/cart/items` — tambah item ke cart
- `DELETE /v1/cart/items/:itemId` — hapus item dari cart
- `POST /v1/orders` — buat order dari cart
- `GET /v1/orders` — daftar pesanan user
- `POST /v1/categories` — tambah kategori (admin)
- `POST /v1/products` — tambah produk (admin)
- `PUT /v1/products/:id` — update produk (admin)
- `DELETE /v1/products/:id` — hapus produk (admin)

## Integrasi Deep Link ke E-Money

Checkout Flutter menggunakan `url_launcher` untuk membuka link:

```
dkg://checkout?store=Hydraulic+Store&order=ORDER_ID&amount=TOTAL_AMOUNT
```

Saat metode pembayaran `E-Money` dipilih, aplikasi akan mencoba membuka `dkg://checkout` dan mengirim data order ke aplikasi Dompet Kampus Global.

## Catatan Tambahan

- Login Flutter menggunakan Firebase Auth dan backend hanya melakukan verifikasi token Firebase.
- Backend mengeluarkan JWT akses agar endpoint protected dapat diakses.
- Jika aplikasi E-Money tidak terpasang, checkout akan gagal dengan notifikasi.
