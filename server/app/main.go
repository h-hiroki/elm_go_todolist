package main

import (
	"github.com/h-hiroki/elm_go_todolist/server/app/handlers"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.CORS()) // 開発中のクラスドメイン対策。todo: これ以外の方法で対応したい

	e.GET("/health_check", handlers.HealthCheck)
	e.Logger.Fatal(e.Start(":1323"))
}
