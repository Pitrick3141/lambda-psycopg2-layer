#!/bin/bash
set -e

echo "Building Psycopg Lambda Layer..."

# Clean previous builds
rm -rf build/
mkdir -p build/python

# Install Psycopg and dependencies
pip install -r requirements.txt -t build/python/

# Remove unnecessary files to reduce layer size
find build/python -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find build/python -name "*.pyc" -delete
find build/python -name "*.pyo" -delete
find build/python -name "*.pyd" -delete
find build/python -name "*.so" -exec strip {} + 2>/dev/null || true

# Remove test files and documentation
find build/python -name "test*" -type f -delete
find build/python -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true
find build/python -name "*.md" -delete
find build/python -name "*.txt" -not -name "requirements.txt" -delete

# Create layer zip
cd build
zip -r psycopg-layer.zip python/
cd ..

echo "Layer built successfully: build/psycopg-layer.zip"
echo "Layer size: $(du -h build/psycopg-layer.zip | cut -f1)"