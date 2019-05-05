package handlers

import (
	"github.com/labstack/echo"
	"net/http"
)

func HealthCheck(context echo.Context) error {
	return context.JSON(http.StatusOK, "health check OK")
}