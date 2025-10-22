# 🏗️ **CipherStudio Project Workflow - Complete Strategic Overview**

## 🎯 **Project Vision & Architecture**

**CipherStudio** is a **cloud-based IDE** that allows users to create, manage, and edit React projects in the browser with real-time preview capabilities. It's built as a **full-stack web application** with modern technologies.

---

## 🏛️ **System Architecture**

```
┌─────────────────────────────────────────────────────────────────┐
│                    CIPHERSTUDIO ECOSYSTEM                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │   FRONTEND      │    │    BACKEND      │    │   STORAGE   │  │
│  │   (React)       │◄──►│   (Node.js)     │◄──►│  (MongoDB   │  │
│  │   Port: 3000    │    │   Port: 5000    │    │   + AWS S3) │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔧 **Technology Stack**

### **Frontend (React Application)**
- **Framework**: React 18 with Hooks
- **IDE Component**: Sandpack (CodeSandbox's browser IDE)
- **Styling**: CSS Modules + Custom CSS
- **State Management**: React Context API
- **HTTP Client**: Axios with interceptors
- **Error Handling**: Global error boundaries
- **Network Management**: Offline support & retry logic

### **Backend (Node.js API)**
- **Framework**: Express.js
- **Database**: MongoDB Atlas (Cloud)
- **File Storage**: AWS S3
- **Validation**: Joi schema validation
- **Error Handling**: Centralized middleware
- **CORS**: Configured for frontend communication

### **Database & Storage**
- **MongoDB Atlas**: Project metadata, file metadata
- **AWS S3**: Actual file content storage
- **Data Models**: User, Project, FileMetadata

---

## 🔄 **Complete User Workflow**

### **1. Application Startup**
```
User opens browser → http://localhost:3000
    ↓
Frontend loads → Checks backend connection
    ↓
Backend status indicator shows connection status
    ↓
User sees main interface with project sidebar
```

### **2. Project Management Workflow**

#### **Creating a Project:**
```
User clicks "Create Project"
    ↓
ProjectManager component opens
    ↓
User enters: name, description
    ↓
Frontend → POST /api/projects → Backend
    ↓
Backend validates data → Creates in MongoDB
    ↓
Returns project with MongoDB ObjectId
    ↓
Frontend updates project list
    ↓
Project appears in sidebar
```

#### **Selecting a Project:**
```
User clicks project in sidebar
    ↓
AppContext updates currentProject
    ↓
SandpackIDE component re-renders
    ↓
Loads project files from backend
    ↓
GET /api/files/project/:id → Backend
    ↓
Backend queries MongoDB + loads content from S3
    ↓
Files appear in Sandpack file explorer
```

### **3. File Management Workflow**

#### **Adding a File:**
```
User clicks "+ Add File" button
    ↓
Dialog opens with filename input
    ↓
User enters filename (e.g., "Component.js")
    ↓
Frontend generates smart content based on extension
    ↓
POST /api/files with:
    {
      projectId: "507f1f77bcf86cd799439011",
      name: "Component.js",
      type: "file",
      content: "import React..."
    }
    ↓
Backend validation (Joi schema):
    - projectId: Must be 24-char hex ObjectId
    - name: Required, 1-255 chars
    - type: Must be "file" or "folder"
    - content: Optional, defaults to empty string
    ↓
Backend creates FileMetadata in MongoDB
    ↓
Backend uploads content to AWS S3
    ↓
Returns success response
    ↓
Frontend adds file to Sandpack
    ↓
File appears in IDE file explorer
```

#### **Editing a File:**
```
User clicks file in Sandpack explorer
    ↓
File opens in code editor
    ↓
User types code
    ↓
Auto-save triggers after 2 seconds
    ↓
PUT /api/files/:id with new content
    ↓
Backend updates S3 content
    ↓
Changes saved automatically
```

#### **Deleting a File:**
```
User right-clicks file in explorer
    ↓
Selects "Delete" from context menu
    ↓
Confirmation dialog appears
    ↓
User confirms deletion
    ↓
DELETE /api/files/:id → Backend
    ↓
Backend removes from MongoDB + S3
    ↓
File disappears from IDE
```

---

## 🗄️ **Data Flow Architecture**

### **Data Models:**

#### **Project Model (MongoDB)**
```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439011"),
  name: "My React App",
  description: "A sample React application",
  userId: "user123",
  createdAt: Date,
  updatedAt: Date
}
```

#### **FileMetadata Model (MongoDB)**
```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439012"),
  projectId: ObjectId("507f1f77bcf86cd799439011"),
  name: "App.js",
  type: "file",
  parentId: null,
  s3Key: "projects/507f1f77bcf86cd799439011/files/App.js",
  size: 1024,
  mimeType: "application/javascript",
  createdAt: Date,
  updatedAt: Date
}
```

#### **File Content (AWS S3)**
```
Bucket: cipherstudio-files-dev1
Key: projects/507f1f77bcf86cd799439011/files/App.js
Content: "import React from 'react';\n\nfunction App() {\n..."
```

---

## 🔐 **Security & Validation**

### **Input Validation (Backend)**
- **Joi Schema Validation**: All API inputs validated
- **ObjectId Validation**: MongoDB ObjectIds must be 24-char hex
- **File Size Limits**: 10MB max for uploads
- **CORS Protection**: Only localhost:3000 allowed in development

### **Error Handling**
- **Frontend**: Global error boundaries + toast notifications
- **Backend**: Centralized error middleware
- **Network**: Retry logic + offline support

---

## 🚀 **Development Workflow**

### **Starting the Application:**
```bash
# Terminal 1: Backend
cd cipher-studio-backend
npm start
# → Server runs on http://localhost:5000

# Terminal 2: Frontend  
cd cipher-studio
npm start
# → App runs on http://localhost:3000
```

### **Development Tools:**
- **Backend Logs**: Real-time API request logging
- **Frontend DevTools**: React DevTools + Network tab
- **Database**: MongoDB Compass for data inspection
- **Storage**: AWS S3 Console for file management

---

## 🔧 **Current Validation Issue & Fix**

### **Problem:**
The validation error occurs because the **projectId format validation** is too strict.

### **Root Cause:**
Your projects might not have valid MongoDB ObjectId format (24-character hexadecimal).

### **Solution:**
Let me check and fix the validation to be more flexible for development: