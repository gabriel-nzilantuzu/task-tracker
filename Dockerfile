FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

# Create a non-root user and group
RUN addgroup --system appuser && adduser --system --ingroup appuser --uid 1000 appuser

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory and install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set permissions for non-root user
RUN chown -R appuser:appuser /app

# Create and set permissions for static files
RUN mkdir -p /static && chown -R appuser:appuser /static

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to non-root user
USER appuser

# Expose the app port
EXPOSE 8000

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
