variable "db_password" {
  description = "Contraseña para el usuario administrador de la base de datos"
  type        = string
  sensitive   = true # 🛡️ Oculta el valor en la consola por seguridad
}

variable "db_name" {
  description = "Nombre de la base de datos para la app de login"
  type        = string
  default     = "db_login_app"
}
