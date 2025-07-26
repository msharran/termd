use thiserror::Error;

/// Custom error types for termd
/// 
/// `thiserror` automatically implements std::error::Error and Display for us
#[derive(Error, Debug)]
pub enum TermdError {
    #[error("Configuration error: {0}")]
    Config(String),

    #[error("Session not found: {name}")]
    SessionNotFound { name: String },

    #[error("Terminal backend error: {message}")]
    Terminal { message: String },

    #[error("Window manager error: {message}")]
    WindowManager { message: String },

    #[error("Project discovery failed: {reason}")]
    ProjectDiscovery { reason: String },

    #[error("Process execution failed: {command}")]
    ProcessExecution { command: String },

    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("TOML parsing error: {0}")]
    TomlParse(#[from] toml::de::Error),
}

/// Type alias for Results that use TermdError
/// This is a common Rust pattern - creates a convenient shorthand
pub type Result<T> = std::result::Result<T, TermdError>;
