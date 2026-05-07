# Stage 1: Builder
FROM python:3.11-slim as builder
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app
# Required for the HEALTHCHECK instruction 
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Run as a non-root user 
RUN useradd -m statuspulse
USER statuspulse
COPY --from=builder /root/.local /home/statuspulse/.local
COPY app/ /app/

ENV PATH=/home/statuspulse/.local/bin:$PATH
# Healthcheck instruction 
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]