FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install virtualenv
RUN pip install virtualenv

# Create a virtual environment for llama stack
RUN virtualenv .venv-kftop

# Set the PATH to use the virtual environment
ENV PATH="/app/.venv-kftop/bin:$PATH"
ENV VIRTUAL_ENV="/app/.venv-kftop"

# Copy requirements file first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the server port
EXPOSE 8321

# Command to start llama stack server
CMD ["llama", "stack", "run", "--image-type", "venv", "run.yaml"]