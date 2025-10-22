# 🚀 **CipherStudio Deployment Guide**

## **Your Deployment Options**

### **Option 1: Frontend (Vercel) + Backend (Render/Railway) - RECOMMENDED**

This is the **easiest and most cost-effective** approach for your setup.

#### **🎨 Frontend Deployment (Vercel)**

**Steps:**
1. **Push your code to GitHub** (if not already)
2. **Connect Vercel to your GitHub repo**
3. **Configure build settings:**
   - **Build Command:** `npm run build`
   - **Output Directory:** `build`
   - **Root Directory:** `cipher-studio`

**Environment Variables in Vercel:**
```env
REACT_APP_API_URL=https://your-backend-url.onrender.com/api
REACT_APP_ENVIRONMENT=production
```

**Vercel Configuration (`vercel.json`):**
```json
{
  "version": 2,
  "builds": [
    {
      "src": "cipher-studio/package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build"
      }
    }
  ],
  "routes": [
    {
      "src": "/static/(.*)",
      "headers": { "cache-control": "s-maxage=31536000,immutable" },
      "dest": "/static/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

#### **⚙️ Backend Deployment (Render/Railway)**

**For Render:**
1. **Connect your GitHub repo**
2. **Select the backend folder:** `cipher-studio-backend`
3. **Configure:**
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Environment:** Node.js

**For Railway:**
1. **Connect GitHub repo**
2. **Select backend service**
3. **Railway will auto-detect Node.js**

**Environment Variables for Backend:**
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cipherstudio
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=cipherstudio-files
JWT_SECRET=your-super-secure-jwt-secret
CORS_ORIGIN=https://your-vercel-app.vercel.app
```

---

### **Option 2: Full Docker Deployment (VPS/Cloud)**

Use your existing Docker setup for complete control.

#### **🐳 Docker Deployment Steps**

**1. Prepare Environment Files:**
```bash
# Copy and configure environment files
cp cipher-studio/.env.example cipher-studio/.env.production
cp cipher-studio-backend/.env.example cipher-studio-backend/.env.production
```

**2. Configure Environment Variables:**

**Frontend (`.env.production`):**
```env
REACT_APP_API_URL=https://your-domain.com/api
REACT_APP_ENVIRONMENT=production
```

**Backend (`.env.production`):**
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cipherstudio
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=cipherstudio-files
JWT_SECRET=your-super-secure-jwt-secret
CORS_ORIGIN=https://your-domain.com
```

**3. Deploy with Docker Compose:**
```bash
# Build and start all services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```

**4. Access Your Application:**
- **Frontend:** http://your-server-ip
- **Backend API:** http://your-server-ip:5000/api
- **Health Check:** http://your-server-ip/health

---

## **🔧 What Your Docker Setup Includes**

### **Frontend Container:**
- **React app** built and optimized
- **Nginx** web server for serving static files
- **Health checks** for monitoring
- **SSL/TLS support** ready
- **Gzip compression** enabled

### **Backend Container:**
- **Node.js/Express** API server
- **Health checks** for monitoring
- **Security** with non-root user
- **Resource limits** configured
- **Auto-restart** on failure

### **Additional Services:**
- **Redis** for caching (optional)
- **MongoDB** local instance (optional)
- **Prometheus** for monitoring (optional)
- **Grafana** for dashboards (optional)

---

## **💰 Cost Comparison**

### **Option 1: Vercel + Render/Railway**
- **Vercel:** Free tier (hobby projects)
- **Render:** $7/month (starter plan)
- **MongoDB Atlas:** Free tier (512MB)
- **AWS S3:** ~$1-5/month
- **Total:** ~$8-12/month

### **Option 2: VPS + Docker**
- **DigitalOcean Droplet:** $6-12/month
- **MongoDB Atlas:** Free tier
- **AWS S3:** ~$1-5/month
- **Total:** ~$7-17/month

---

## **🎯 Recommended Approach**

**For Your CipherStudio Project, I recommend Option 1:**

### **Why Option 1 is Better:**
✅ **Easier deployment** - No server management  
✅ **Auto-scaling** - Handles traffic spikes  
✅ **Built-in CDN** - Faster global performance  
✅ **Zero downtime** deployments  
✅ **Automatic SSL** certificates  
✅ **Git-based** deployments  
✅ **Free tier** available  

### **When to Use Option 2:**
- Need **full control** over infrastructure
- **Custom networking** requirements
- **Compliance** requirements
- **Cost optimization** for high traffic

---

## **🚀 Quick Start (Option 1)**

### **Step 1: Deploy Backend**
1. Go to [Render.com](https://render.com) or [Railway.app](https://railway.app)
2. Connect your GitHub repository
3. Select `cipher-studio-backend` folder
4. Add environment variables
5. Deploy!

### **Step 2: Deploy Frontend**
1. Go to [Vercel.com](https://vercel.com)
2. Connect your GitHub repository
3. Set root directory to `cipher-studio`
4. Add `REACT_APP_API_URL` environment variable
5. Deploy!

### **Step 3: Configure Database**
1. Create [MongoDB Atlas](https://cloud.mongodb.com) cluster
2. Get connection string
3. Update backend environment variables

### **Step 4: Configure File Storage**
1. Create AWS S3 bucket
2. Get access keys
3. Update backend environment variables

---

## **🔍 Your Docker Benefits**

Even if you choose Option 1, your Docker setup provides:

### **Development Benefits:**
- **Consistent environment** across team
- **Easy local testing** of production setup
- **Quick environment setup** for new developers

### **Future Migration:**
- **Easy migration** to any cloud provider
- **Kubernetes deployment** ready
- **Microservices architecture** prepared

### **Backup Deployment:**
- **Alternative deployment** method
- **On-premises** deployment option
- **Full control** when needed

---

## **📋 Next Steps**

**Choose your deployment approach:**

**🎯 For Quick Deployment (Recommended):**
1. Deploy backend to Render/Railway
2. Deploy frontend to Vercel
3. Configure MongoDB Atlas
4. Set up AWS S3

**🐳 For Docker Deployment:**
1. Get a VPS (DigitalOcean, AWS EC2, etc.)
2. Configure environment files
3. Run Docker Compose
4. Set up domain and SSL

**Need help with any specific step? Let me know!** 🚀