import unittest
from fastapi.testclient import TestClient
from app.main import app

class TestMain(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)

    def test_read_main(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"message": "Hello World"})