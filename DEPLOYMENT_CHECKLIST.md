# ✅ **CipherStudio Deployment Checklist**

## **Pre-Deployment Setup**

### **🗄️ Database (MongoDB Atlas)**
- [ ] Create MongoDB Atlas account
- [ ] Create free cluster (M0 Sandbox)
- [ ] Create database user with read/write permissions
- [ ] Configure network access (allow all IPs: 0.0.0.0/0)
- [ ] Get connection string
- [ ] Test connection string

### **📁 File Storage (AWS S3)**
- [ ] Create AWS account
- [ ] Create S3 bucket with unique name
- [ ] Configure bucket policy for public read access
- [ ] Create IAM user with S3 full access
- [ ] Get Access Key ID and Secret Access Key
- [ ] Test S3 upload/download

### **📝 Code Preparation**
- [ ] Push all code to GitHub
- [ ] Verify `vercel.json` is in root directory
- [ ] Verify frontend `package.json` has build script
- [ ] Verify backend `package.json` has start script
- [ ] Test application locally

---

## **Backend Deployment (Render)**

### **🚀 Deploy Backend**
- [ ] Go to [Render.com](https://render.com)
- [ ] Sign up/Login with GitHub
- [ ] Create new Web Service
- [ ] Connect GitHub repository
- [ ] Configure service:
  - Name: `cipherstudio-backend`
  - Root Directory: `cipher-studio-backend`
  - Build Command: `npm install`
  - Start Command: `npm start`

### **⚙️ Environment Variables**
Add these in Render dashboard:
- [ ] `NODE_ENV=production`
- [ ] `PORT=10000`
- [ ] `MONGODB_URI=your-mongodb-connection-string`
- [ ] `AWS_ACCESS_KEY_ID=your-aws-access-key`
- [ ] `AWS_SECRET_ACCESS_KEY=your-aws-secret-key`
- [ ] `AWS_REGION=us-east-1`
- [ ] `S3_BUCKET_NAME=your-s3-bucket-name`
- [ ] `JWT_SECRET=your-secure-random-string`
- [ ] `CORS_ORIGIN=*` (will update after frontend deployment)

### **✅ Backend Testing**
- [ ] Wait for deployment to complete
- [ ] Note backend URL: `https://your-service.onrender.com`
- [ ] Test health endpoint: `/api/health`
- [ ] Check logs for any errors

---

## **Frontend Deployment (Vercel)**

### **🚀 Deploy Frontend**
- [ ] Go to [Vercel.com](https://vercel.com)
- [ ] Sign up/Login with GitHub
- [ ] Import GitHub repository
- [ ] Configure project:
  - Framework: `Create React App`
  - Root Directory: `cipher-studio`
  - Build Command: `npm run build`
  - Output Directory: `build`

### **⚙️ Environment Variables**
Add these in Vercel dashboard:
- [ ] `REACT_APP_API_URL=https://your-backend.onrender.com/api`
- [ ] `REACT_APP_ENVIRONMENT=production`

### **✅ Frontend Testing**
- [ ] Wait for deployment to complete
- [ ] Note frontend URL: `https://your-project.vercel.app`
- [ ] Test if application loads
- [ ] Check browser console for errors

---

## **Final Configuration**

### **🔗 Update CORS**
- [ ] Go back to Render dashboard
- [ ] Update `CORS_ORIGIN` to your Vercel URL
- [ ] Redeploy backend service

### **🧪 End-to-End Testing**
- [ ] Visit your Vercel URL
- [ ] Test user registration/login (if implemented)
- [ ] Create a new project
- [ ] Add files to project
- [ ] Edit file content
- [ ] Test file rename functionality
- [ ] Test file delete functionality
- [ ] Test live preview updates
- [ ] Check if files persist after refresh

---

## **Post-Deployment**

### **📊 Monitoring**
- [ ] Check Render service logs
- [ ] Check Vercel function logs
- [ ] Monitor MongoDB Atlas metrics
- [ ] Monitor AWS S3 usage

### **🔒 Security**
- [ ] Verify CORS is properly configured
- [ ] Check that sensitive data is not exposed
- [ ] Verify environment variables are set correctly
- [ ] Test rate limiting (if implemented)

### **📈 Performance**
- [ ] Test application speed
- [ ] Check Vercel analytics
- [ ] Monitor Render performance metrics
- [ ] Optimize if needed

---

## **🎯 Success Criteria**

Your deployment is successful when:
- ✅ Frontend loads without errors
- ✅ Backend API responds to health checks
- ✅ Database connection is working
- ✅ File upload/download works
- ✅ Project creation/management works
- ✅ File operations (create, edit, rename, delete) work
- ✅ Live preview updates correctly
- ✅ No CORS errors in browser console

---

## **🆘 Troubleshooting**

### **Common Issues:**

**Backend won't start:**
- Check Render logs for errors
- Verify environment variables
- Check MongoDB connection string

**CORS errors:**
- Verify CORS_ORIGIN matches Vercel URL exactly
- Check if backend is running
- Redeploy backend after CORS update

**Database connection failed:**
- Check MongoDB Atlas network access
- Verify connection string format
- Check database user permissions

**File upload errors:**
- Verify AWS credentials
- Check S3 bucket policy
- Verify bucket name in environment variables

**Frontend build fails:**
- Check Vercel build logs
- Verify package.json scripts
- Check for missing dependencies

---

## **📞 Support Resources**

- **Render Documentation:** [render.com/docs](https://render.com/docs)
- **Vercel Documentation:** [vercel.com/docs](https://vercel.com/docs)
- **MongoDB Atlas:** [docs.atlas.mongodb.com](https://docs.atlas.mongodb.com)
- **AWS S3:** [docs.aws.amazon.com/s3](https://docs.aws.amazon.com/s3)

---

**Ready to deploy? Follow the step-by-step guide and check off each item!** 🚀