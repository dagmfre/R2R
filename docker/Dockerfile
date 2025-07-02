FROM python:3.12-slim AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc g++ musl-dev curl libffi-dev gfortran libopenblas-dev \
    poppler-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy Python project files
COPY py/pyproject.toml py/
COPY py/ py/

# Install Python dependencies
RUN cd py && pip install -e ".[core]" && \
    pip install gunicorn uvicorn

# Create the final image
FROM python:3.12-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl poppler-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the built environment from builder
COPY --from=builder /usr/local /usr/local

WORKDIR /app

# Copy the Python application
COPY py/ .

# Copy custom configs (if needed)
COPY docker/user_configs/ custom_configs/

# Set environment variables
ENV R2R_PORT=7272
ENV R2R_HOST=0.0.0.0

# Expose port
EXPOSE 7272

# Start command
CMD ["uvicorn", "core.main.app_entry:app", "--host", "0.0.0.0", "--port", "7272"]