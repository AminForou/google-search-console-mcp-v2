FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Create data directory for SQLite
RUN mkdir -p /app/data

# Environment variables (override in deployment)
ENV DATABASE_PATH=/app/data/gsc_tokens.db
ENV PORT=8000

# Expose port
EXPOSE 8000

# Run with gunicorn for production
CMD ["gunicorn", "gsc_server_remote:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]

