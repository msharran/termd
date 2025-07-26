use clap::Parser;
use termd::cli::{Cli, Commands};

fn main() {
    let cli = Cli::parse();
    
    match cli.command {
        Commands::ChangeSession { create, interactive, path } => {
            println!("Change session - create: {}, interactive: {}, path: {:?}", 
                    create, interactive, path);
        }
        Commands::ListSessions => {
            println!("List sessions");
        }
        Commands::GetSession => {
            println!("Show current session");
        }
    }
}
