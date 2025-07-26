use serde::{Deserialize, Serialize};
use std::path::PathBuf;
use crate::{Result, TermdError};

/// Configuration for termd
/// 
/// The #[derive(Serialize, Deserialize)] automatically generates code
/// to convert between this struct and TOML format
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    /// Directories to search for projects
    pub search_paths: Vec<SearchPath>,
    
    /// Terminal backend to use (default: "kitty")
    #[serde(default = "default_terminal")]
    pub terminal: String,
    
    /// Window manager backend to use (default: "aerospace")
    #[serde(default = "default_window_manager")]
    pub window_manager: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SearchPath {
    /// Base directory to search
    pub path: PathBuf,
    
    /// Maximum depth to search (default: 1)
    #[serde(default = "default_depth")]
    pub depth: u8,
    
    /// Whether to include hidden directories (default: false)
    #[serde(default)]
    pub include_hidden: bool,
}

// Default value functions for serde
fn default_terminal() -> String {
    "kitty".to_string()
}

fn default_window_manager() -> String {
    "aerospace".to_string()
}

fn default_depth() -> u8 {
    1
}

impl Default for Config {
    fn default() -> Self {
        let home = dirs::home_dir().unwrap_or_else(|| PathBuf::from("/"));
        
        Config {
            search_paths: vec![
                SearchPath {
                    path: home,
                    depth: 1,
                    include_hidden: false,
                },
            ],
            terminal: default_terminal(),
            window_manager: default_window_manager(),
        }
    }
}

impl Config {
    /// Load configuration from file, falling back to default if it doesn't exist
    pub fn load() -> Result<Self> {
        let config_path = Self::find_config_file()?;
        
        if let Some(path) = config_path {
            let content = std::fs::read_to_string(&path)
                .map_err(|e| TermdError::Config(format!("Failed to read config file: {}", e)))?;
            
            let config: Config = toml::from_str(&content)?;
            Ok(config)
        } else {
            // Return default config if no file exists
            Ok(Config::default())
        }
    }
    
    /// Find configuration file, checking multiple locations
    /// On macOS, checks both ~/.config/termd/config.toml and ~/Library/Application Support/termd/config.toml
    fn find_config_file() -> Result<Option<PathBuf>> {
        let home = dirs::home_dir()
            .ok_or_else(|| TermdError::Config("Could not determine home directory".to_string()))?;
        
        // Candidate paths to check (in order of preference)
        let candidates = vec![
            home.join(".config").join("termd").join("config.toml"), // Linux-style (preferred)
            dirs::config_dir()
                .map(|dir| dir.join("termd").join("config.toml")) // OS-specific
                .unwrap_or_else(|| home.join(".termd").join("config.toml")), // Fallback
        ];
        
        // Return the first existing config file
        for path in candidates {
            if path.exists() {
                return Ok(Some(path));
            }
        }
        
        Ok(None)
    }
}