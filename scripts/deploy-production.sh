#!/bin/bash

# CipherStudio Production Deployment Script
# This script deploys CipherStudio to production using Docker Compose

set -e

echo "🚀 Starting CipherStudio Production Deployment..."

# Check if required files exist
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "❌ docker-compose.prod.yml not found!"
    exit 1
fi

if [ ! -f "cipher-studio/.env.production" ]; then
    echo "❌ Frontend production environment file not found!"
    exit 1
fi

if [ ! -f "cipher-studio-backend/.env.production" ]; then
    echo "❌ Backend production environment file not found!"
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down

# Remove old images (optional - uncomment if you want to force rebuild)
# echo "🗑️  Removing old images..."
# docker-compose -f docker-compose.prod.yml down --rmi all

# Build and start services
echo "🏗️  Building and starting services..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Health check
echo "🔍 Performing health checks..."

# Check backend health
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health || echo "000")
if [ "$BACKEND_HEALTH" = "200" ]; then
    echo "✅ Backend health check passed"
else
    echo "❌ Backend health check failed (HTTP $BACKEND_HEALTH)"
    echo "📋 Backend logs:"
    docker-compose -f docker-compose.prod.yml logs backend
    exit 1
fi

# Check frontend availability
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80 || echo "000")
if [ "$FRONTEND_HEALTH" = "200" ]; then
    echo "✅ Frontend health check passed"
else
    echo "❌ Frontend health check failed (HTTP $FRONTEND_HEALTH)"
    echo "📋 Frontend logs:"
    docker-compose -f docker-compose.prod.yml logs frontend
    exit 1
fi

# Check MongoDB connection
echo "🔍 Checking database connection..."
MONGO_CHECK=$(docker-compose -f docker-compose.prod.yml exec -T backend node -e "
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGODB_URI || 'mongodb://mongo:27017/cipherstudio')
  .then(() => { console.log('DB_OK'); process.exit(0); })
  .catch(() => { console.log('DB_ERROR'); process.exit(1); });
" 2>/dev/null || echo "DB_ERROR")

if [ "$MONGO_CHECK" = "DB_OK" ]; then
    echo "✅ Database connection check passed"
else
    echo "❌ Database connection check failed"
    echo "📋 Database logs:"
    docker-compose -f docker-compose.prod.yml logs mongo
    exit 1
fi

# Display running services
echo "📊 Deployment Status:"
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🎉 CipherStudio deployed successfully!"
echo ""
echo "📍 Application URLs:"
echo "   Frontend: http://localhost"
echo "   Backend API: http://localhost:5000"
echo "   Health Check: http://localhost:5000/health"
echo ""
echo "📋 Useful Commands:"
echo "   View logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "   Stop services: docker-compose -f docker-compose.prod.yml down"
echo "   Restart services: docker-compose -f docker-compose.prod.yml restart"
echo ""
echo "🔧 Monitoring:"
if [ -f "monitoring/prometheus.yml" ]; then
    echo "   Prometheus: http://localhost:9090"
    echo "   Setup monitoring: ./scripts/setup-monitoring.sh"
fi
echo ""