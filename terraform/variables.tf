variable "db_name" {
  description = "Nombre de la base de datos PostgreSQL"
  type        = string
  default     = "login_db"
}

variable "db_password" {
  description = "Contraseña para el usuario de la base de datos"
  type        = string
  sensitive   = true
  default     = "SuperPasswordSeguro123!" # 💡 Valor por defecto para pruebas de laboratorio
}