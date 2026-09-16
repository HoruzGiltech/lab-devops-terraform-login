import pytest
from app.main import app

@pytest.fixture
def client():
    """Configura un cliente de pruebas para simular peticiones HTTP."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_healthz(client):
    """Prueba que la ruta /healthz devuelva un status 200 y 'healthy' 🩺"""
    response = client.get('/healthz')
    assert response.status_code == 200
    assert response.json == {"status": "healthy", "service": "login-app"}
