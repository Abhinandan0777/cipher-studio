# Requirements Document

## Introduction

CipherStudio is a full-stack, browser-based React IDE that enables users to create, edit, run, save, and reload multi-file React projects in real-time. The application provides an IDE-like interface with file management, code editing, live preview capabilities, and project persistence. The system uses React/Next.js for the frontend, Sandpack for code execution, Node.js/Express for the backend, MongoDB Atlas for metadata storage, and AWS S3 for file content storage.

## Requirements

### Requirement 1

**User Story:** As a developer, I want to manage files and folders in a hierarchical structure, so that I can organize my React project components effectively.

#### Acceptance Criteria

1. WHEN a user creates a new file THEN the system SHALL add the file to the current directory with a default name
2. WHEN a user creates a new folder THEN the system SHALL add the folder to the current directory and allow nested folder creation
3. WHEN a user deletes a file THEN the system SHALL remove the file from both the UI and backend storage
4. WHEN a user deletes a folder THEN the system SHALL recursively delete all contained files and subfolders
5. IF a user attempts to delete a non-empty folder THEN the system SHALL prompt for confirmation before proceeding
6. WHEN a user navigates the file tree THEN the system SHALL display the hierarchical structure with expandable/collapsible folders

### Requirement 2

**User Story:** As a developer, I want a rich code editor for writing React components, so that I can write code efficiently with syntax highlighting and IntelliSense.

#### Acceptance Criteria

1. WHEN a user opens a file THEN the system SHALL display the file content in the Monaco Editor with appropriate syntax highlighting
2. WHEN a user types in the editor THEN the system SHALL provide real-time syntax validation and error highlighting
3. WHEN a user saves a file (Ctrl+S) THEN the system SHALL persist the changes to the backend storage
4. WHEN a user switches between files THEN the system SHALL preserve unsaved changes and restore file content accurately
5. IF a file has unsaved changes THEN the system SHALL indicate this visually in the file tab or explorer

### Requirement 3

**User Story:** As a developer, I want to see my React application running in real-time, so that I can immediately see the results of my code changes.

#### Acceptance Criteria

1. WHEN a user makes code changes THEN the system SHALL automatically refresh the preview within 2 seconds
2. WHEN the React code has compilation errors THEN the system SHALL display error messages in the preview pane
3. WHEN the React application runs successfully THEN the system SHALL display the rendered output in the preview pane
4. IF the preview encounters runtime errors THEN the system SHALL display error boundaries with clear error messages
5. WHEN a user interacts with the preview THEN the system SHALL maintain the application state during code updates

### Requirement 4

**User Story:** As a developer, I want to save and load my projects, so that I can persist my work and continue development across sessions.

#### Acceptance Criteria

1. WHEN a user creates a new project THEN the system SHALL generate a unique projectId and initialize with default React files
2. WHEN a user saves a project THEN the system SHALL store project metadata in MongoDB and file contents in AWS S3
3. WHEN a user loads a project by projectId THEN the system SHALL restore the complete file structure and content
4. WHEN a user updates project files THEN the system SHALL sync changes to both MongoDB (metadata) and S3 (content)
5. IF a project load fails THEN the system SHALL display an appropriate error message and fallback options
6. WHEN a user accesses their projects THEN the system SHALL display a list of all their saved projects with metadata

### Requirement 5

**User Story:** As a developer, I want an intuitive IDE-like interface, so that I can work efficiently with familiar development patterns.

#### Acceptance Criteria

1. WHEN the application loads THEN the system SHALL display three main sections: File Explorer (left), Code Editor (center), and Live Preview (right)
2. WHEN a user resizes panels THEN the system SHALL maintain responsive layout and preserve panel proportions
3. WHEN a user interacts with the interface THEN the system SHALL provide visual feedback for all actions (loading states, hover effects, etc.)
4. WHEN the application is used on different screen sizes THEN the system SHALL adapt the layout appropriately
5. IF the user interface becomes unresponsive THEN the system SHALL display loading indicators and maintain usability

### Requirement 6

**User Story:** As a developer, I want reliable data persistence, so that my project files and structure are safely stored and retrievable.

#### Acceptance Criteria

1. WHEN the system stores file hierarchy THEN it SHALL use parentId relationships to maintain folder structure in MongoDB
2. WHEN a file is created THEN the system SHALL store metadata in MongoDB and content in S3 with a unique s3Key
3. WHEN a folder is created THEN the system SHALL store only metadata in MongoDB with parentId reference and no s3Key
4. WHEN the root folder is created THEN the system SHALL set parentId to null to indicate project root
5. IF database operations fail THEN the system SHALL implement retry logic and provide user feedback
6. WHEN file content is updated THEN the system SHALL maintain version consistency between MongoDB metadata and S3 content

### Requirement 7

**User Story:** As a developer, I want comprehensive REST APIs, so that the frontend can perform all necessary project and file operations.

#### Acceptance Criteria

1. WHEN creating a project THEN the POST /api/projects endpoint SHALL return the new project with generated ID
2. WHEN fetching user projects THEN the GET /api/projects/:userId endpoint SHALL return all projects for that user
3. WHEN updating a project THEN the PUT /api/projects/:id endpoint SHALL update both metadata and associated files
4. WHEN deleting a project THEN the DELETE /api/projects/:id endpoint SHALL remove all associated files and S3 content
5. WHEN creating files/folders THEN the POST /api/files endpoint SHALL handle both file and folder creation with proper parentId
6. WHEN deleting files/folders THEN the DELETE /api/files/:id endpoint SHALL recursively handle children and S3 cleanup
7. IF API requests fail THEN the system SHALL return appropriate HTTP status codes and error messages

### Requirement 8

**User Story:** As a developer, I want the system to handle errors gracefully, so that I can continue working even when issues occur.

#### Acceptance Criteria

1. WHEN network requests fail THEN the system SHALL display user-friendly error messages and retry options
2. WHEN code compilation fails THEN the system SHALL show detailed error information in the preview pane
3. WHEN file operations fail THEN the system SHALL provide specific error feedback and suggest corrective actions
4. IF the application crashes THEN the system SHALL attempt to recover and preserve unsaved work
5. WHEN external services are unavailable THEN the system SHALL degrade gracefully and inform the user