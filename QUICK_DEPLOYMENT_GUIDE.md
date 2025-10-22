# 🚀 **Quick CipherStudio Deployment Guide**

## **Your Setup: Vercel + Railway (Using Your Existing AWS S3 & MongoDB)**

Since you already have AWS S3 and MongoDB Atlas configured, we'll use:
- ✅ **Frontend:** Vercel (Free)
- ✅ **Backend:** Railway (Free - $5 credit monthly)
- ✅ **Database:** Your existing MongoDB Atlas
- ✅ **Storage:** Your existing AWS S3

---

## **Step 1: Deploy Backend to Railway (FREE)**

### **1.1 Create Railway Account**
1. Go to [Railway.app](https://railway.app)
2. **Sign up with GitHub** (free, no credit card needed)
3. You get **$5 monthly credit** (enough for small apps)

### **1.2 Deploy Backend**
1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Connect your GitHub repository
4. Select your repository
5. Railway will auto-detect Node.js in `cipher-studio-backend`

### **1.3 Configure Root Directory**
1. In Railway dashboard, go to **Settings**
2. Set **Root Directory** to: `cipher-studio-backend`
3. **Build Command:** `npm install`
4. **Start Command:** `npm start`

### **1.4 Add Environment Variables**
In Railway dashboard, go to **Variables** and add:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=your-existing-mongodb-connection-string
AWS_ACCESS_KEY_ID=your-existing-aws-access-key
AWS_SECRET_ACCESS_KEY=your-existing-aws-secret-key
AWS_REGION=your-aws-region
S3_BUCKET_NAME=your-existing-s3-bucket-name
JWT_SECRET=your-super-secure-random-string-here-make-it-long-and-random
CORS_ORIGIN=*
```

### **1.5 Deploy**
1. Railway automatically starts deploying
2. Wait 3-5 minutes for deployment
3. You'll get a URL like: `https://your-app-name.railway.app`
4. Test it: `https://your-app-name.railway.app/api/health`

---

## **Step 2: Deploy Frontend to Vercel (FREE)**

### **2.1 Create Vercel Account**
1. Go to [Vercel.com](https://vercel.com)
2. **Sign up with GitHub** (free)

### **2.2 Deploy Frontend**
1. Click **"New Project"**
2. **Import** your GitHub repository
3. Configure project settings:
   - **Framework Preset:** `Create React App`
   - **Root Directory:** `cipher-studio`
   - **Build Command:** `npm run build`
   - **Output Directory:** `build`
   - **Install Command:** `npm install`

### **2.3 Add Environment Variables**
In Vercel dashboard, go to **Settings** → **Environment Variables**:

```env
REACT_APP_API_URL=https://your-app-name.railway.app/api
REACT_APP_ENVIRONMENT=production
```

### **2.4 Deploy**
1. Click **"Deploy"**
2. Wait 2-3 minutes for build and deployment
3. You'll get a URL like: `https://your-project-name.vercel.app`

---

## **Step 3: Update CORS Configuration**

### **3.1 Update Backend CORS**
1. Go back to **Railway dashboard**
2. Update the **CORS_ORIGIN** environment variable:
   ```env
   CORS_ORIGIN=https://your-project-name.vercel.app
   ```
3. Railway will automatically redeploy

---

## **Step 4: Test Your Deployment**

### **4.1 Test Backend**
Visit: `https://your-app-name.railway.app/api/health`
Should return:
```json
{
  "status": "OK",
  "timestamp": "2024-01-XX...",
  "environment": "production"
}
```

### **4.2 Test Frontend**
1. Visit: `https://your-project-name.vercel.app`
2. Should load CipherStudio interface
3. Check browser console for any errors

### **4.3 Test Full Integration**
1. **Create a new project**
2. **Add some files** (test file creation)
3. **Edit file content** (test file editing)
4. **Rename files** (test your new rename feature)
5. **Delete files** (test file deletion)
6. **Check live preview** updates

---

## **🎉 You're Live!**

Your CipherStudio is now deployed at:
- **Frontend:** `https://your-project-name.vercel.app`
- **Backend:** `https://your-app-name.railway.app`
- **Database:** Your existing MongoDB Atlas
- **Storage:** Your existing AWS S3

---

## **💰 Free Tier Details**

### **Railway (Backend)**
- ✅ **$5 credit monthly** (resets each month)
- ✅ **No sleep time** (always available)
- ✅ **500MB RAM, 1 vCPU**
- ✅ **Perfect for your app size**

### **Vercel (Frontend)**
- ✅ **100GB bandwidth/month**
- ✅ **Unlimited deployments**
- ✅ **Global CDN**
- ✅ **Custom domains** (if you want)

### **Your Existing Services**
- ✅ **MongoDB Atlas:** Free tier (512MB)
- ✅ **AWS S3:** Pay per usage (~$1-3/month for small projects)

**Total estimated cost: $1-3/month** (just AWS S3 usage)

---

## **🔧 Troubleshooting**

### **Backend Issues:**
- **Check Railway logs:** Dashboard → Deployments → View Logs
- **Environment variables:** Make sure all are set correctly
- **MongoDB connection:** Test your connection string

### **Frontend Issues:**
- **Check Vercel logs:** Dashboard → Functions → View Function Logs
- **CORS errors:** Make sure CORS_ORIGIN matches your Vercel URL exactly
- **API calls failing:** Check if backend URL is correct

### **Common Fixes:**
1. **CORS Error:** Update CORS_ORIGIN in Railway to exact Vercel URL
2. **Backend not responding:** Check Railway logs for startup errors
3. **Database connection:** Verify MongoDB Atlas allows connections from anywhere (0.0.0.0/0)
4. **S3 errors:** Check AWS credentials and bucket permissions

---

## **🚀 Quick Commands**

### **Test Locally Before Deploying:**
```bash
# Test backend
cd cipher-studio-backend
npm install
npm start

# Test frontend (in another terminal)
cd cipher-studio
npm install
npm start
```

### **Push Changes:**
```bash
git add .
git commit -m "Ready for deployment"
git push origin main
```

Both Railway and Vercel will **automatically redeploy** when you push to GitHub!

---

## **✅ Deployment Checklist**

- [ ] Railway account created
- [ ] Backend deployed to Railway
- [ ] All environment variables added to Railway
- [ ] Backend health check working
- [ ] Vercel account created
- [ ] Frontend deployed to Vercel
- [ ] Frontend environment variables added
- [ ] CORS updated with Vercel URL
- [ ] Full end-to-end testing completed
- [ ] File operations working (create, edit, rename, delete)

---

**Ready to deploy? This should take about 15-20 minutes total!** 🚀

**Need help with any step? Just ask!** 💪