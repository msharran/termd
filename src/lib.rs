pub mod error;
pub mod cli;
pub mod config;
pub mod session;

// Re-export our Result type for easy use
pub use error::{Result, TermdError};