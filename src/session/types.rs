use std::path::PathBuf;

/// Represents a terminal session
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Session {
    /// Display name for the session (abbreviated path)
    pub name: String,
    
    /// Full path to the directory
    pub path: PathBuf,
    
    /// Whether this session is currently active
    pub is_active: bool,
}

/// Information about an existing session (lighter than full Session)
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SessionInfo {
    /// Session name
    pub name: String,
    
    /// Full path
    pub path: PathBuf,
}

/// Represents a window in the window manager
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct WindowInfo {
    /// Window ID (backend-specific)
    pub id: WindowId,
    
    /// Window title
    pub title: String,
    
    /// Application name
    pub app_name: String,
}

/// Window identifier - could be numeric or string depending on backend
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum WindowId {
    /// Numeric window ID (like X11)
    Numeric(u64),
    
    /// String window ID (like some macOS window managers)
    String(String),
}

impl Session {
    /// Create a new session
    pub fn new(name: String, path: PathBuf) -> Self {
        Session {
            name,
            path,
            is_active: false,
        }
    }
    
    /// Create from a SessionInfo
    pub fn from_info(info: SessionInfo) -> Self {
        Session {
            name: info.name,
            path: info.path,
            is_active: false,
        }
    }
}

impl SessionInfo {
    /// Create new session info
    pub fn new(name: String, path: PathBuf) -> Self {
        SessionInfo { name, path }
    }
}