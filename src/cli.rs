use clap::{Parser, Subcommand};
use std::path::PathBuf;

/// Terminal session manager
#[derive(Parser)]
#[command(name = "termd")]
#[command(about = "A terminal session manager that helps you switch between projects")]
#[command(version = "0.1.0")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Change to a session (matches the shell script behavior)
    #[command(name = "change-session")]
    ChangeSession {
        /// Create new session if it doesn't exist
        #[arg(short, long)]
        create: bool,
        
        /// Use interactive mode (fuzzy finder)
        #[arg(short, long)]
        interactive: bool,
        
        /// Specific path to open (optional, defaults to interactive selection)
        path: Option<PathBuf>,
    },
    
    /// List all available sessions
    #[command(name = "list-sessions")]
    ListSessions,
    
    /// Get current session info
    #[command(name = "get-session")]
    GetSession,
}
