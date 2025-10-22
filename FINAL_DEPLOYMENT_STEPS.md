# 🚀 **CipherStudio Step-by-Step Deployment Guide**

## **Prerequisites ✅**
- ✅ Your backend is working locally
- ✅ AWS S3 is configured
- ✅ MongoDB Atlas is configured
- ✅ Code is pushed to GitHub

---

## **STEP 1: Deploy Backend to Railway (10 minutes)**

### **1.1 Create Railway Account**
1. Open [Railway.app](https://railway.app) in your browser
2. Click **"Login"** 
3. Click **"Login with GitHub"**
4. Authorize Railway to access your GitHub account
5. You'll get **$5 free credit monthly** (no credit card needed)

### **1.2 Create New Project**
1. Click **"New Project"** button
2. Select **"Deploy from GitHub repo"**
3. Find and select your **cipher-studio repository**
4. Railway will start analyzing your repo

### **1.3 Configure Backend Service**
1. Railway will detect both frontend and backend folders
2. Click on the **backend service** (it should auto-detect Node.js)
3. Go to **"Settings"** tab
4. Set **"Root Directory"** to: `cipher-studio-backend`
5. **Build Command:** `npm install` (should be auto-detected)
6. **Start Command:** `npm start` (should be auto-detected)

### **1.4 Add Environment Variables**
1. Go to **"Variables"** tab
2. Click **"New Variable"** and add each of these:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://your-username:your-password@your-cluster.mongodb.net/cipherstudio?retryWrites=true&w=majority
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-s3-bucket-name
JWT_SECRET=your-super-secure-random-string-at-least-32-characters-long
CORS_ORIGIN=*
```

**⚠️ Replace with your actual values:**
- `MONGODB_URI`: Your MongoDB Atlas connection string
- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `S3_BUCKET_NAME`: Your S3 bucket name
- `JWT_SECRET`: Generate a long random string

### **1.5 Deploy Backend**
1. Click **"Deploy"** button
2. Wait 3-5 minutes for deployment
3. You'll see build logs in real-time
4. Once complete, you'll get a URL like: `https://cipher-studio-backend-production.up.railway.app`

### **1.6 Test Backend**
1. Copy your Railway backend URL
2. Test it by visiting: `https://your-backend-url.railway.app/api/health`
3. You should see: `{"status":"OK","timestamp":"..."}`

---

## **STEP 2: Deploy Frontend to Vercel (5 minutes)**

### **2.1 Create Vercel Account**
1. Open [Vercel.com](https://vercel.com) in your browser
2. Click **"Sign Up"**
3. Click **"Continue with GitHub"**
4. Authorize Vercel to access your GitHub account

### **2.2 Import Project**
1. Click **"New Project"**
2. Find your **cipher-studio repository**
3. Click **"Import"**

### **2.3 Configure Frontend**
1. **Framework Preset:** Should auto-detect "Create React App"
2. **Root Directory:** Change to `cipher-studio`
3. **Build Command:** `npm run build` (auto-detected)
4. **Output Directory:** `build` (auto-detected)
5. **Install Command:** `npm install` (auto-detected)

### **2.4 Add Environment Variables**
1. Click **"Environment Variables"** section
2. Add these variables:

```env
REACT_APP_API_URL=https://your-backend-url.railway.app/api
REACT_APP_ENVIRONMENT=production
```

**⚠️ Replace `your-backend-url.railway.app` with your actual Railway URL from Step 1.5**

### **2.5 Deploy Frontend**
1. Click **"Deploy"**
2. Wait 2-3 minutes for build and deployment
3. You'll get a URL like: `https://cipher-studio-abc123.vercel.app`

---

## **STEP 3: Update CORS Configuration (2 minutes)**

### **3.1 Update Backend CORS**
1. Go back to **Railway dashboard**
2. Click on your backend service
3. Go to **"Variables"** tab
4. Find the **CORS_ORIGIN** variable
5. Update it to your Vercel URL: `https://cipher-studio-abc123.vercel.app`
6. Click **"Update"**
7. Railway will automatically redeploy (takes 1-2 minutes)

---

## **STEP 4: Test Your Deployment (5 minutes)**

### **4.1 Test Backend Health**
Visit: `https://your-backend-url.railway.app/api/health`
✅ Should return: `{"status":"OK",...}`

### **4.2 Test Frontend**
1. Visit: `https://your-frontend-url.vercel.app`
2. ✅ Should load CipherStudio interface
3. ✅ Check browser console (F12) - no CORS errors

### **4.3 Test Full Integration**
1. **Create a new project** ✅
2. **Add some files** ✅
3. **Edit file content** ✅
4. **Test file rename** (your new feature!) ✅
5. **Test file delete** ✅
6. **Check live preview updates** ✅

---

## **🎉 CONGRATULATIONS! Your CipherStudio is Live!**

### **Your Live URLs:**
- **Frontend:** `https://your-project.vercel.app`
- **Backend:** `https://your-backend.railway.app`

### **💰 Cost Breakdown:**
- **Railway:** FREE ($5 monthly credit)
- **Vercel:** FREE (100GB bandwidth)
- **MongoDB Atlas:** FREE (512MB)
- **AWS S3:** ~$1-3/month (very low usage)
- **Total:** ~$1-3/month

---

## **🔧 Troubleshooting**

### **Backend Issues:**
**Problem:** Backend won't start
**Solution:** 
1. Check Railway logs: Dashboard → Deployments → View Logs
2. Verify all environment variables are set
3. Test MongoDB connection string locally

**Problem:** "Module not found" errors
**Solution:**
1. Check if `package.json` is in `cipher-studio-backend` folder
2. Verify Root Directory is set to `cipher-studio-backend`

### **Frontend Issues:**
**Problem:** CORS errors in browser
**Solution:**
1. Make sure CORS_ORIGIN in Railway matches your Vercel URL exactly
2. Wait 2 minutes after updating CORS for Railway to redeploy

**Problem:** API calls failing
**Solution:**
1. Check if `REACT_APP_API_URL` in Vercel matches your Railway URL
2. Make sure Railway backend is running (check health endpoint)

### **Database Issues:**
**Problem:** Database connection failed
**Solution:**
1. Check MongoDB Atlas network access allows 0.0.0.0/0
2. Verify connection string format
3. Test connection string locally first

---

## **🚀 Next Steps (Optional)**

### **Custom Domain (Free)**
1. **Vercel:** Settings → Domains → Add your domain
2. **Railway:** Settings → Domains → Add your domain

### **Monitoring**
1. **Railway:** Built-in metrics and logs
2. **Vercel:** Built-in analytics and performance monitoring

### **Scaling**
- Both platforms auto-scale
- Railway: Upgrade to paid plan for more resources
- Vercel: Automatic global CDN and edge functions

---

## **📞 Support**

**If you get stuck:**
1. **Railway:** [docs.railway.app](https://docs.railway.app)
2. **Vercel:** [vercel.com/docs](https://vercel.com/docs)
3. **Check logs** in both platforms for specific error messages

---

**🎯 Total Time: ~20 minutes**
**💰 Total Cost: ~$1-3/month**
**🚀 Result: Professional, scalable, live application!**

**Ready to start? Begin with Step 1! 🚀**