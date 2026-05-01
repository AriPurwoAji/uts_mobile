package services

import (
	"context"
	"errors"
	"os"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/AriPurwoAji/gin-firebase-backend/config"
	"github.com/AriPurwoAji/gin-firebase-backend/models"
	"github.com/AriPurwoAji/gin-firebase-backend/repositories"
	"gorm.io/gorm"
)

type AuthService struct {
	userRepo *repositories.UserRepository
}

func NewAuthService() *AuthService {
	return &AuthService{userRepo: repositories.NewUserRepository()}
}

func (s *AuthService) VerifyFirebaseToken(firebaseToken string) (string, *models.User, error) {
	// 1. Verifikasi Firebase ID Token
	token, err := config.FirebaseAuth.VerifyIDToken(context.Background(), firebaseToken)
	if err != nil {
		return "", nil, errors.New("firebase token tidak valid atau kadaluarsa")
	}

	// 2. Cek email sudah diverifikasi
	emailVerified, _ := token.Claims["email_verified"].(bool)
	if !emailVerified {
		return "", nil, errors.New("EMAIL_NOT_VERIFIED")
	}

	// 3. Ambil data dari claims
	uid := token.UID
	email, _ := token.Claims["email"].(string)
	name, _ := token.Claims["name"].(string)

	// 4. Cari user di database
user, err := s.userRepo.FindByFirebaseUID(uid)

if errors.Is(err, gorm.ErrRecordNotFound) {
    // Coba cari by email dulu (user mungkin sudah ada dengan UID berbeda)
    existingUser, emailErr := s.userRepo.FindByEmail(email)
    
    if emailErr == nil {
        // User ditemukan by email → update firebase_uid-nya
        existingUser.FirebaseUID    = uid
        existingUser.EmailVerified  = true
        now := time.Now().Unix()
        existingUser.LastLoginAt    = &now
        if err := s.userRepo.Update(existingUser); err != nil {
            return "", nil, errors.New("gagal update user")
        }
        user = existingUser
    } else {
        // Benar-benar user baru → buat baru
        now := time.Now().Unix()
        user = &models.User{
            FirebaseUID:   uid,
            Email:         email,
            Name:          name,
            Role:          "user",
            EmailVerified: true,
            LastLoginAt:   &now,
        }
        if err := s.userRepo.Create(user); err != nil {
            return "", nil, errors.New("gagal membuat user baru")
        }
    }
} else if err != nil {
    return "", nil, errors.New("error mengambil data user")
} else {
    // User sudah ada → update last login
    now := time.Now().Unix()
    user.LastLoginAt   = &now
    user.EmailVerified = true
    s.userRepo.Update(user)
}

	// 5. Generate Backend JWT Token
	jwtToken, err := s.generateJWT(user)
	if err != nil {
		return "", nil, errors.New("gagal membuat token")
	}

	return jwtToken, user, nil
}

func (s *AuthService) generateJWT(user *models.User) (string, error) {
	expireHours, _ := strconv.Atoi(os.Getenv("JWT_EXPIRE_HOURS"))
	if expireHours == 0 {
		expireHours = 24
	}

	claims := jwt.MapClaims{
		"sub":            user.ID,
		"firebase_uid":   user.FirebaseUID,
		"email":          user.Email,
		"name":           user.Name,
		"role":           user.Role,
		"email_verified": user.EmailVerified,
		"iat":            time.Now().Unix(),
		"exp":            time.Now().Add(time.Hour * time.Duration(expireHours)).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(os.Getenv("JWT_SECRET")))
}