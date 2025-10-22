#!/bin/bash

# CipherStudio Production Monitoring Setup Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root for security reasons"
   exit 1
fi

log "Starting CipherStudio monitoring setup..."

# Create monitoring directories
log "Creating monitoring directories..."
mkdir -p monitoring/{prometheus,grafana/{dashboards,datasources},alertmanager}
mkdir -p logs/{prometheus,grafana,alertmanager}

# Set up Prometheus configuration
log "Setting up Prometheus configuration..."
if [ ! -f monitoring/prometheus/prometheus.yml ]; then
    cp monitoring/prometheus.yml monitoring/prometheus/prometheus.yml
    log "Prometheus configuration created"
else
    warn "Prometheus configuration already exists"
fi

# Set up Grafana datasources
log "Setting up Grafana datasources..."
if [ ! -f monitoring/grafana/datasources/prometheus.yml ]; then
    cp monitoring/grafana/datasources/prometheus.yml monitoring/grafana/datasources/
    log "Grafana datasources configured"
else
    warn "Grafana datasources already configured"
fi

# Create Grafana dashboard configuration
log "Setting up Grafana dashboards..."
if [ ! -f monitoring/grafana/dashboards/dashboard.yml ]; then
    cp monitoring/grafana/dashboards/dashboard.yml monitoring/grafana/dashboards/
    log "Grafana dashboards configured"
else
    warn "Grafana dashboards already configured"
fi

# Create alerting rules
log "Creating alerting rules..."
cat > monitoring/prometheus/rules/cipherstudio.yml << 'EOF'
groups:
  - name: cipherstudio.rules
    rules:
      # High error rate
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors per second"

      # High response time
      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time detected"
          description: "95th percentile response time is {{ $value }} seconds"

      # Service down
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          description: "{{ $labels.instance }} has been down for more than 1 minute"

      # High memory usage
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage is above 90%"

      # High CPU usage
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage"
          description: "CPU usage is above 80%"

      # Disk space low
      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Disk space low"
          description: "Disk space is below 10%"
EOF

# Create alertmanager configuration
log "Setting up Alertmanager..."
cat > monitoring/alertmanager/alertmanager.yml << 'EOF'
global:
  smtp_smarthost: 'localhost:587'
  smtp_from: 'alerts@cipherstudio.com'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'

receivers:
  - name: 'web.hook'
    email_configs:
      - to: 'admin@cipherstudio.com'
        subject: 'CipherStudio Alert: {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
EOF

# Create monitoring docker-compose file
log "Creating monitoring docker-compose configuration..."
cat > docker-compose.monitoring.yml << 'EOF'
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: cipherstudio-prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus:/etc/prometheus:ro
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
      - '--web.enable-admin-api'
    restart: unless-stopped
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: cipherstudio-grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
      - GF_USERS_ALLOW_SIGN_UP=false
      - GF_INSTALL_PLUGINS=grafana-piechart-panel
    volumes:
      - grafana-data:/var/lib/grafana
      - ./monitoring/grafana/dashboards:/etc/grafana/provisioning/dashboards:ro
      - ./monitoring/grafana/datasources:/etc/grafana/provisioning/datasources:ro
      - ./logs/grafana:/var/log/grafana
    depends_on:
      - prometheus
    restart: unless-stopped
    networks:
      - monitoring

  alertmanager:
    image: prom/alertmanager:latest
    container_name: cipherstudio-alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./monitoring/alertmanager:/etc/alertmanager:ro
      - alertmanager-data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
      - '--web.external-url=http://localhost:9093'
    restart: unless-stopped
    networks:
      - monitoring

  node-exporter:
    image: prom/node-exporter:latest
    container_name: cipherstudio-node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped
    networks:
      - monitoring

volumes:
  prometheus-data:
  grafana-data:
  alertmanager-data:

networks:
  monitoring:
    driver: bridge
EOF

# Set proper permissions
log "Setting up permissions..."
chmod +x docker-entrypoint.sh
chmod +x cipher-studio-backend/scripts/health-check.js
chmod 600 ssl/* 2>/dev/null || warn "SSL certificates not found - configure them before deployment"

# Create systemd service for auto-start
log "Creating systemd service..."
sudo tee /etc/systemd/system/cipherstudio.service > /dev/null << EOF
[Unit]
Description=CipherStudio Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/cipherstudio
ExecStart=/usr/local/bin/docker-compose -f docker-compose.prod.yml up -d
ExecStop=/usr/local/bin/docker-compose -f docker-compose.prod.yml down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable cipherstudio.service

log "Monitoring setup completed successfully!"
log ""
log "Next steps:"
log "1. Configure your environment variables in .env.production files"
log "2. Set up SSL certificates in the ssl/ directory"
log "3. Run: docker-compose -f docker-compose.prod.yml up -d"
log "4. Start monitoring: docker-compose -f docker-compose.monitoring.yml up -d"
log "5. Access Grafana at http://localhost:3000 (admin/admin)"
log "6. Access Prometheus at http://localhost:9090"
log ""
log "For detailed instructions, see DEPLOYMENT.md"