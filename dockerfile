# --- Этап 1: Базовый образ и зависимости ---
    FROM python:3.12-slim AS base
    WORKDIR /app
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    # Для тестов нужен httpx (используется TestClient)
    RUN pip install --no-cache-dir httpx 
    
    # --- Этап 2: Тестирование ---
    FROM base AS tester
    COPY . .
    # Запуск unittest. Если тесты упадут, сборка образа остановится.
    RUN python -m unittest discover tests
    
    # --- Этап 3: Финальный образ (Production) ---
    FROM base AS runtime
    COPY ./app /app/app
    EXPOSE 8000
    # Запуск приложения через uvicorn
    CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]