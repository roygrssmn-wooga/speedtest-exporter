FROM python:3.11-slim

# Install speedtest CLI and wget for healthcheck
RUN apt-get update && \
    apt-get install -y curl wget && \
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get install -y speedtest && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY src/ .

# Expose the port
EXPOSE 9798

# Run the application
CMD ["python", "-u", "exporter.py"]

# Healthcheck with fixed port
HEALTHCHECK --timeout=10s CMD wget --no-verbose --tries=1 --spider http://localhost:9798/
