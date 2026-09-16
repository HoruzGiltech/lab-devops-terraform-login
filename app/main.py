import os
from flask import Flask, jsonify, render_template_string
from google.cloud import secretmanager

app = Flask(__name__)

def obtener_secreto_db(project_id: str, secret_id: str = "db-password-login") -> str:
    """Consulta la última versión de la contraseña en Secret Manager."""
    try:
        client = secretmanager.SecretManagerServiceClient()
        name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
        response = client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")
    except Exception as e:
        print(f"Error al obtener secreto: {e}")
        return "ErrorDeConexion"

@app.route("/healthz")
def health_check():
    """Ruta para comprobar que la aplicación está viva y saludable 🩺"""
    return jsonify({"status": "healthy", "service": "login-app"}), 200

@app.route("/")
def index():
    """Formulario básico de login 📝"""
    html_template = """
    <!DOCTYPE html>
    <html>
    <head><title>Sistema de Login</title></head>
    <body style="font-family: Arial; text-align: center; margin-top: 50px;">
        <h2>🔐 Iniciar Sesión</h2>
        <form action="/login" method="post">
            <input type="text" name="username" placeholder="Usuario" required><br><br>
            <input type="password" name="password" placeholder="Contraseña" required><br><br>
            <button type="submit">Ingresar</button>
        </form>
    </body>
    </html>
    """
    return render_template_string(html_template)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
