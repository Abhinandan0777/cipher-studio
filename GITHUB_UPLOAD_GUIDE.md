# 📤 **Upload CipherStudio to GitHub - Step by Step**

## **STEP 0: Prerequisites**
- ✅ Your project is working locally
- ✅ You have a GitHub account (if not, create one at [github.com](https://github.com))

---

## **STEP 1: Create .gitignore File**

First, let's create a `.gitignore` file to exclude sensitive files and dependencies:

### **1.1 Create .gitignore in Root Directory**
Create a file called `.gitignore` in your main project folder (same level as `cipher-studio` and `cipher-studio-backend` folders):

```gitignore
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables (IMPORTANT - keeps your secrets safe!)
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
cipher-studio/.env
cipher-studio-backend/.env

# Build outputs
cipher-studio/build/
cipher-studio/dist/
cipher-studio-backend/build/
cipher-studio-backend/dist/

# Logs
logs
*.log
cipher-studio/logs/
cipher-studio-backend/logs/

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env.test

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Temporary files
*.tmp
*.temp

# Docker
docker-compose.override.yml

# SSL certificates
ssl/
*.pem
*.key
*.crt

# Backup files
*.backup
*.bak

# Database dumps
*.sql
*.dump
```

---

## **STEP 2: Initialize Git Repository**

### **2.1 Open Terminal/Command Prompt**
Navigate to your main project directory (where both `cipher-studio` and `cipher-studio-backend` folders are):

```bash
cd "D:\React IDE"
```

### **2.2 Initialize Git**
```bash
git init
```

### **2.3 Add All Files**
```bash
git add .
```

### **2.4 Create First Commit**
```bash
git commit -m "Initial commit: CipherStudio React IDE with file management features"
```

---

## **STEP 3: Create GitHub Repository**

### **3.1 Go to GitHub**
1. Open [github.com](https://github.com) in your browser
2. Sign in to your account
3. Click the **"+"** button in the top right
4. Select **"New repository"**

### **3.2 Configure Repository**
1. **Repository name:** `cipher-studio`
2. **Description:** `A React-based IDE with live preview, file management, and code editing capabilities`
3. **Visibility:** Choose **Public** (recommended) or **Private**
4. **DO NOT** check "Add a README file" (we already have one)
5. **DO NOT** check "Add .gitignore" (we already created one)
6. **DO NOT** check "Choose a license" (optional)
7. Click **"Create repository"**

---

## **STEP 4: Connect Local Repository to GitHub**

### **4.1 Add Remote Origin**
GitHub will show you commands after creating the repo. Use these commands:

```bash
git remote add origin https://github.com/YOUR_USERNAME/cipher-studio.git
```

**Replace `YOUR_USERNAME` with your actual GitHub username**

### **4.2 Push to GitHub**
```bash
git branch -M main
git push -u origin main
```

---

## **STEP 5: Verify Upload**

### **5.1 Check GitHub**
1. Refresh your GitHub repository page
2. You should see all your files uploaded
3. Check that you have both `cipher-studio/` and `cipher-studio-backend/` folders
4. Verify that `.env` files are **NOT** visible (they should be ignored)

### **5.2 Important Security Check**
**🚨 CRITICAL:** Make sure these files are **NOT** visible on GitHub:
- `cipher-studio-backend/.env`
- Any files containing passwords, API keys, or secrets

If you see any `.env` files on GitHub:
1. Delete them immediately from the repository
2. Change all passwords/keys that were exposed
3. Update your `.gitignore` file

---

## **STEP 6: Create Environment Example Files**

### **6.1 Create Backend .env.example**
Create `cipher-studio-backend/.env.example` with placeholder values:

```env
# Server Configuration
NODE_ENV=development
PORT=5000

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/database

# AWS S3 Configuration
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-s3-bucket-name

# Security
JWT_SECRET=your-super-secure-jwt-secret-key

# CORS
CORS_ORIGIN=http://localhost:3000
```

### **6.2 Create Frontend .env.example**
Create `cipher-studio/.env.example`:

```env
# API Configuration
REACT_APP_API_URL=http://localhost:5000/api
REACT_APP_ENVIRONMENT=development
```

### **6.3 Commit Example Files**
```bash
git add .
git commit -m "Add environment example files for deployment setup"
git push
```

---

## **🎉 SUCCESS! Your Project is on GitHub**

### **Your Repository URL:**
`https://github.com/YOUR_USERNAME/cipher-studio`

### **What's Next:**
Now you can proceed with deployment:
1. **Railway** will connect to your GitHub repo for backend
2. **Vercel** will connect to your GitHub repo for frontend
3. Both platforms will automatically deploy when you push updates

---

## **📋 Quick Commands Summary**

```bash
# Navigate to your project
cd "D:\React IDE"

# Initialize git
git init
git add .
git commit -m "Initial commit: CipherStudio React IDE"

# Connect to GitHub (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/cipher-studio.git
git branch -M main
git push -u origin main
```

---

## **🔧 Troubleshooting**

### **Problem:** "Permission denied" error
**Solution:** 
1. Make sure you're logged into GitHub
2. Use personal access token instead of password
3. Or use GitHub Desktop app

### **Problem:** Files too large
**Solution:**
1. Check if `node_modules/` folders are being uploaded
2. Make sure `.gitignore` is working
3. Remove `node_modules/` manually: `rm -rf */node_modules/`

### **Problem:** .env files visible on GitHub
**Solution:**
1. **IMMEDIATELY** delete the repository
2. Change all passwords/keys
3. Fix `.gitignore` and re-upload

---

**Ready to upload to GitHub? Follow the steps above, then we can proceed with deployment! 🚀**