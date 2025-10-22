# 🚀 AWS S3 Setup for CipherStudio

## Quick Setup Guide

### 1. Create Free AWS Account
1. Go to https://aws.amazon.com/
2. Click "Create an AWS Account"
3. Fill in your details (email, password, account name)
4. Choose "Personal" account type
5. Add payment method (required but free tier won't charge)
6. Verify phone number
7. Choose "Basic support - Free"

### 2. Create S3 Bucket
1. Login to AWS Console: https://console.aws.amazon.com/
2. Search for "S3" in services
3. Click "Create bucket"
4. **Bucket Configuration**:
   - **Name**: `cipherstudio-files-dev` (must be globally unique)
   - **Region**: `us-east-1` (or closest to you)
   - **Block public access**: ✅ Keep enabled
   - **Versioning**: Disable (saves space)
   - **Encryption**: Enable SSE-S3
5. Click "Create bucket"

### 3. Create IAM User
1. Go to IAM service in AWS Console
2. Click "Users" → "Create user"
3. **User Configuration**:
   - **Username**: `cipherstudio-backend`
   - **Access type**: Programmatic access
4. **Permissions**:
   - Click "Attach policies directly"
   - Search and select: `AmazonS3FullAccess`
5. **Review and create**
6. **IMPORTANT**: Download the CSV with credentials!

### 4. Update Environment File
Replace in `cipher-studio-backend/.env`:

```env
# Replace with your actual AWS credentials from the CSV
AWS_ACCESS_KEY_ID=AKIA...your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=cipherstudio-files-dev
```

### 5. Test Connection
```bash
cd cipher-studio-backend
node test-aws-s3.js
```

## ✅ Success Indicators

You should see:
```
✅ Successfully connected to AWS S3
✅ Target bucket found: cipherstudio-files-dev
✅ Test file uploaded successfully
✅ Test file downloaded successfully
✅ Objects listed successfully
✅ Test file deleted successfully
🎉 AWS S3 is fully configured and working!
```

## 💰 AWS Free Tier Benefits

- **5 GB** of S3 storage (plenty for development)
- **20,000 GET requests** per month
- **2,000 PUT requests** per month
- **15 GB** of data transfer out
- **Valid for 12 months** from account creation

## 🔧 Troubleshooting

### Invalid Access Key
- Double-check AWS_ACCESS_KEY_ID in .env
- Ensure no extra spaces or characters

### Signature Does Not Match
- Double-check AWS_SECRET_ACCESS_KEY in .env
- Ensure the secret key is complete

### No Such Bucket
- Check S3_BUCKET_NAME matches exactly
- Ensure bucket exists in the correct region

### Access Denied
- Verify IAM user has S3FullAccess policy
- Check bucket permissions

## 🎯 What This Enables

Once configured, your CipherStudio will:
- ✅ **Store files in AWS S3** instead of local storage
- ✅ **Handle large files** efficiently
- ✅ **Provide file backup** and redundancy
- ✅ **Scale automatically** as you add more projects
- ✅ **Work from anywhere** with cloud storage

## 🔒 Security Best Practices

- Never commit AWS credentials to git
- Use environment variables only
- Regularly rotate access keys
- Monitor AWS usage in console
- Set up billing alerts for safety