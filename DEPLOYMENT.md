# CipherStudio Deployment Guide

This guide covers deploying CipherStudio in production environments using Docker containers.

## Architecture Overview

CipherStudio consists of three main components:
- **Frontend**: React application served by Nginx
- **Backend**: Node.js/Express API server
- **Database**: MongoDB Atlas (cloud) or MongoDB instance
- **Storage**: AWS S3 for file storage

## Prerequisites

- Docker and Docker Compose installed
- MongoDB Atlas account or MongoDB instance
- AWS S3 bucket and credentials
- Domain name (optional, for custom domains)

## Quick Start with Docker Compose

1. **Clone the repository**
```bash
git clone <repository-url>
cd cipher-studio
```

2. **Configure environment variables**
```bash
# Copy environment templates
cp cipher-studio/.env.example cipher-studio/.env.production
cp cipher-studio-backend/.env.example cipher-studio-backend/.env.production

# Edit the environment files with your configuration
```

3. **Build and start services**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

4. **Access the application**
- Frontend: http://localhost (or your domain)
- Backend API: http://localhost/api
- Health checks: http://localhost/health

## Environment Configuration

### Frontend Environment Variables

Create `cipher-studio/.env.production`:

```env
# API Configuration
REACT_APP_API_URL=https://your-api-domain.com/api
REACT_APP_ENVIRONMENT=production

# Feature Flags
REACT_APP_ENABLE_ANALYTICS=true
REACT_APP_ENABLE_ERROR_REPORTING=true

# Performance
REACT_APP_ENABLE_SERVICE_WORKER=true
REACT_APP_CACHE_VERSION=1.0.0

# Security
REACT_APP_CSP_NONCE=auto-generated
```

### Backend Environment Variables

Create `cipher-studio-backend/.env.production`:

```env
# Server Configuration
NODE_ENV=production
PORT=5000
HOST=0.0.0.0

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cipherstudio
DB_NAME=cipherstudio

# AWS S3 Configuration
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=cipherstudio-files

# Security
JWT_SECRET=your-super-secure-jwt-secret-key
BCRYPT_ROUNDS=12
CORS_ORIGIN=https://your-frontend-domain.com

# Monitoring
LOG_LEVEL=info
ENABLE_REQUEST_LOGGING=true
HEALTH_CHECK_INTERVAL=30000

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

## Production Deployment Options

### Option 1: Docker Compose (Recommended for single server)

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  frontend:
    build:
      context: ./cipher-studio
      dockerfile: Dockerfile
    ports:
      - "80:80"
      - "443:443"
    environment:
      - REACT_APP_API_URL=${FRONTEND_API_URL}
      - REACT_APP_ENVIRONMENT=production
    volumes:
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - backend
    restart: unless-stopped

  backend:
    build:
      context: ./cipher-studio-backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    env_file:
      - ./cipher-studio-backend/.env.production
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "node", "scripts/health-check.js"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  default:
    name: cipherstudio-network
```

### Option 2: Kubernetes Deployment

Create Kubernetes manifests in `k8s/` directory:

```yaml
# k8s/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cipherstudio

---
# k8s/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cipherstudio-frontend
  namespace: cipherstudio
spec:
  replicas: 3
  selector:
    matchLabels:
      app: cipherstudio-frontend
  template:
    metadata:
      labels:
        app: cipherstudio-frontend
    spec:
      containers:
      - name: frontend
        image: cipherstudio/frontend:latest
        ports:
        - containerPort: 80
        env:
        - name: REACT_APP_API_URL
          value: "https://api.cipherstudio.com/api"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

---
# k8s/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cipherstudio-backend
  namespace: cipherstudio
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cipherstudio-backend
  template:
    metadata:
      labels:
        app: cipherstudio-backend
    spec:
      containers:
      - name: backend
        image: cipherstudio/backend:latest
        ports:
        - containerPort: 5000
        envFrom:
        - secretRef:
            name: cipherstudio-secrets
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Option 3: Cloud Platform Deployment

#### AWS ECS/Fargate
- Use the provided Dockerfiles
- Configure Application Load Balancer
- Set up CloudWatch logging
- Use AWS Secrets Manager for environment variables

#### Google Cloud Run
- Deploy containers directly from Docker images
- Configure custom domains
- Set up Cloud SQL for MongoDB alternative
- Use Secret Manager for configuration

#### Azure Container Instances
- Deploy using Azure Container Registry
- Configure Azure Database for MongoDB
- Set up Application Gateway for load balancing

## SSL/TLS Configuration

### Using Let's Encrypt with Certbot

1. **Install Certbot**
```bash
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx
```

2. **Obtain SSL certificate**
```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

3. **Auto-renewal setup**
```bash
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Manual SSL Configuration

Update `nginx.conf` to include SSL:

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    
    # ... rest of configuration
}
```

## Monitoring and Logging

### Application Monitoring

1. **Health Checks**
   - Frontend: `GET /health`
   - Backend: `GET /api/health`

2. **Metrics Collection**
   - Use Prometheus for metrics
   - Grafana for visualization
   - Custom dashboards for performance monitoring

3. **Error Tracking**
   - Sentry integration for error reporting
   - Custom error logging to files
   - Real-time error notifications

### Log Management

1. **Centralized Logging**
```bash
# Using ELK Stack
docker run -d --name elasticsearch elasticsearch:7.14.0
docker run -d --name kibana --link elasticsearch kibana:7.14.0
docker run -d --name logstash --link elasticsearch logstash:7.14.0
```

2. **Log Rotation**
```bash
# Configure logrotate
sudo nano /etc/logrotate.d/cipherstudio
```

## Performance Optimization

### Frontend Optimization

1. **Build Optimization**
```json
{
  "scripts": {
    "build:prod": "GENERATE_SOURCEMAP=false npm run build",
    "analyze": "npm run build && npx webpack-bundle-analyzer build/static/js/*.js"
  }
}
```

2. **CDN Configuration**
   - Use CloudFront or similar CDN
   - Configure proper cache headers
   - Enable gzip compression

### Backend Optimization

1. **Database Optimization**
   - Enable MongoDB connection pooling
   - Create proper indexes
   - Use read replicas for scaling

2. **Caching Strategy**
   - Redis for session storage
   - Application-level caching
   - CDN for static assets

## Security Considerations

### Network Security

1. **Firewall Configuration**
```bash
# UFW rules
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

2. **Container Security**
   - Run containers as non-root users
   - Use minimal base images
   - Regular security updates

### Application Security

1. **Environment Variables**
   - Never commit secrets to version control
   - Use secret management services
   - Rotate secrets regularly

2. **API Security**
   - Rate limiting enabled
   - CORS properly configured
   - Input validation and sanitization

## Backup and Recovery

### Database Backup

```bash
# MongoDB backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mongodump --uri="$MONGODB_URI" --out="/backups/mongodb_$DATE"
aws s3 cp "/backups/mongodb_$DATE" "s3://your-backup-bucket/mongodb/" --recursive
```

### File Storage Backup

```bash
# S3 cross-region replication
aws s3api put-bucket-replication \
  --bucket source-bucket \
  --replication-configuration file://replication.json
```

## Scaling Considerations

### Horizontal Scaling

1. **Load Balancing**
   - Use Nginx or HAProxy
   - Configure health checks
   - Session affinity if needed

2. **Database Scaling**
   - MongoDB sharding
   - Read replicas
   - Connection pooling

### Vertical Scaling

1. **Resource Monitoring**
   - CPU and memory usage
   - Database performance
   - Network I/O

2. **Auto-scaling**
   - Kubernetes HPA
   - AWS Auto Scaling Groups
   - Cloud platform auto-scaling

## Troubleshooting

### Common Issues

1. **Container Won't Start**
```bash
# Check logs
docker logs container-name
# Check resource usage
docker stats
```

2. **Database Connection Issues**
```bash
# Test MongoDB connection
mongosh "mongodb+srv://cluster.mongodb.net/test"
# Check network connectivity
telnet mongodb-host 27017
```

3. **File Upload Issues**
```bash
# Check S3 permissions
aws s3 ls s3://your-bucket --profile your-profile
# Test S3 connectivity
aws s3 cp test.txt s3://your-bucket/
```

### Performance Issues

1. **Slow API Responses**
   - Check database query performance
   - Monitor network latency
   - Review application logs

2. **High Memory Usage**
   - Analyze memory leaks
   - Optimize database queries
   - Review caching strategies

## Maintenance

### Regular Tasks

1. **Security Updates**
```bash
# Update base images
docker pull node:18-alpine
docker pull nginx:alpine
# Rebuild containers
docker-compose build --no-cache
```

2. **Database Maintenance**
```bash
# MongoDB maintenance
db.runCommand({compact: "collection_name"})
db.runCommand({reIndex: "collection_name"})
```

3. **Log Cleanup**
```bash
# Clean old logs
find /var/log -name "*.log" -mtime +30 -delete
# Clean Docker logs
docker system prune -f
```

### Monitoring Checklist

- [ ] Application health checks passing
- [ ] Database connections stable
- [ ] SSL certificates valid
- [ ] Backup processes running
- [ ] Security patches applied
- [ ] Performance metrics within acceptable ranges
- [ ] Error rates below threshold
- [ ] Storage usage monitored

## Support and Documentation

### Additional Resources

- [API Documentation](./API.md)
- [Architecture Overview](./ARCHITECTURE.md)
- [Development Setup](./README.md)
- [Security Guidelines](./SECURITY.md)

### Getting Help

- GitHub Issues: [Repository Issues](https://github.com/your-org/cipher-studio/issues)
- Documentation: [Wiki](https://github.com/your-org/cipher-studio/wiki)
- Community: [Discussions](https://github.com/your-org/cipher-studio/discussions)

---

**Note**: This deployment guide assumes a production environment. For development or staging deployments, adjust the configuration accordingly and consider using development-specific settings.