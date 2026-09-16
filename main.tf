provider "google" {
  project = "laboratorio-terraform-508817" # 👈 Reemplaza con el ID de tu proyecto de GCP
  region  = "us-central1"
}

resource "google_storage_bucket" "mi_bucket" {
  name                     = "mi-bucket-devops-terraform-lab-unique-12345" # 👈 Debe ser un nombre globalmente único
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true
}

output "bucket_url" {
  description = "URL del bucket creado"
  value       = google_storage_bucket.mi_bucket.url
}
# 1. Instancia de Base de Datos Cloud SQL (PostgreSQL)
resource "google_sql_database_instance" "db_instance" {
  name             = "instancia-login-lab"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro" # 💡 Tipo de máquina económica ideal para pruebas
  }

  deletion_protection = false # ⚠️ Permite eliminar la instancia fácilmente en el laboratorio
}

# 2. Base de datos para la aplicación
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}

# 3. Usuario de la base de datos con contraseña sensible
resource "google_sql_user" "db_user" {
  name     = "app_user"
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password # 🔑 Usa la variable que declaramos
}


# 4. Crear un Secreto en Secret Manager
resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "db-password-login"

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

# 5. Guardar el valor de la contraseña dentro del Secreto
resource "google_secret_manager_secret_version" "db_password_secret_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = var.db_password
}
