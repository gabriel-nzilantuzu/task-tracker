#!/bin/sh

# Exit if any command fails
set -e

# Run Django DB migrations
echo "Running makemigrations..."
python manage.py makemigrations --noinput

echo "Running migrate..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start the application
echo "Starting Gunicorn..."
exec gunicorn --bind 0.0.0.0:8000 task_tracker.wsgi:application
