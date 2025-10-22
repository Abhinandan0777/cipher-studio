# 🎯 CipherStudio - Professional React IDE

A modern, web-based React development environment with real-time preview, file management, and cloud storage.

## ✨ Features

- **🚀 Real-time Code Preview** - Instant updates with Sandpack integration
- **📁 Smart File Management** - Create, edit, and organize files effortlessly
- **💾 Auto-save** - Never lose your work with automatic saving
- **🎨 Beautiful Templates** - Start with professional React project templates
- **☁️ Cloud Storage** - MongoDB + AWS S3 integration for persistent storage
- **🔧 Professional Tools** - Full-featured IDE experience in your browser

## 🏗️ Architecture

### Frontend (`cipher-studio/`)
- **React 18** with modern hooks and context
- **Sandpack** for real-time code execution and preview
- **Professional UI** with responsive design
- **Error boundaries** and comprehensive error handling

### Backend (`cipher-studio-backend/`)
- **Node.js + Express** REST API
- **MongoDB** for project and file metadata
- **AWS S3** for file content storage
- **Robust validation** and error handling

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- MongoDB Atlas account
- AWS S3 bucket (optional for development)

### 1. Backend Setup
```bash
cd cipher-studio-backend
npm install
cp .env.example .env
# Configure your MongoDB URI in .env
npm start
```

### 2. Frontend Setup
```bash
cd cipher-studio
npm install
npm start
```

### 3. Access Your IDE
Open http://localhost:3000 in your browser

## 🔧 Configuration

### Environment Variables

**Backend (`.env`):**
```env
MONGODB_URI=your_mongodb_connection_string
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=your_aws_region
S3_BUCKET_NAME=your_s3_bucket_name
PORT=5000
```

**Frontend (`.env`):**
```env
REACT_APP_API_URL=http://localhost:5000/api
```

## 📁 Project Structure

```
cipher-studio/
├── 📂 cipher-studio/              # Frontend React application
│   ├── 📂 src/
│   │   ├── 📂 components/         # React components
│   │   ├── 📂 services/           # API services
│   │   ├── 📂 context/            # React context
│   │   └── 📂 utils/              # Utility functions
│   └── 📄 package.json
├── 📂 cipher-studio-backend/      # Backend Node.js API
│   ├── 📂 controllers/            # Route controllers
│   ├── 📂 models/                 # MongoDB models
│   ├── 📂 routes/                 # API routes
│   ├── 📂 services/               # Business logic
│   ├── 📂 utils/                  # Utility functions
│   └── 📄 package.json
├── 📂 monitoring/                 # Production monitoring
├── 📂 scripts/                    # Deployment scripts
└── 📄 README.md
```

## 🎯 Usage

### Creating Projects
1. Click "Create Project" in the sidebar
2. Enter project name and description
3. Enjoy 3 auto-generated React files with beautiful templates

### Managing Files
- **Add files:** Click "+ Add File" in the file explorer
- **Edit files:** Click on any file to open in the editor
- **Delete files:** Right-click and select delete
- **Auto-save:** Changes save automatically after 2 seconds

### Real-time Preview
- See your changes instantly in the preview pane
- Full React application with hot reloading
- Professional development experience

## 🚀 Deployment

### Production Deployment
```bash
# Build frontend
cd cipher-studio
npm run build

# Deploy backend
cd ../cipher-studio-backend
npm run start:prod
```

### Docker Deployment
```bash
docker-compose up -d
```

## 🛠️ Development

### Running in Development
```bash
# Terminal 1 - Backend
cd cipher-studio-backend
npm run dev

# Terminal 2 - Frontend  
cd cipher-studio
npm start
```

### Testing
```bash
# Backend tests
cd cipher-studio-backend
npm test

# Frontend tests
cd cipher-studio
npm test
```

## 📚 API Documentation

### Projects API
- `GET /api/projects/user/:userId` - Get user projects
- `POST /api/projects` - Create new project
- `GET /api/projects/:id` - Get project details
- `PUT /api/projects/:id` - Update project
- `DELETE /api/projects/:id` - Delete project

### Files API
- `GET /api/files/project/:projectId` - Get project files
- `POST /api/files` - Create new file
- `GET /api/files/:id` - Get file content
- `PUT /api/files/:id` - Update file
- `DELETE /api/files/:id` - Delete file

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🎉 Enjoy Building!

CipherStudio provides a professional React development environment right in your browser. Start creating amazing projects today!

---

**Built with ❤️ for developers who love clean, powerful tools.**