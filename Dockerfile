FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

# Create a non-root user and group (UID/GID 1000)
RUN addgroup --system appuser && adduser --system --ingroup appuser --uid 1000 appuser

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory and adjust permissions
WORKDIR /app
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set permissions for the non-root user
RUN chown -R appuser:appuser /app

# Create a directory for static files (adjust as needed)
RUN mkdir -p /static && chown -R appuser:appuser /static

# Switch to the non-root user
USER appuser

# Expose the port for Gunicorn
EXPOSE 8000

# Run the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "task_tracker.wsgi:application"]
