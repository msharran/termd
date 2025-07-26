# Step-by-Step Rust Learning Implementation Plan

## Learning Approach
I'll guide you through each step, explaining Rust concepts like:
- Ownership and borrowing
- Traits and trait objects
- Error handling with Result<T, E>
- Async/await programming
- Pattern matching
- Module system
- Cargo dependency management

## Implementation Steps with Learning Focus

### Step 1: Dependencies & Project Setup ✅ COMPLETED
- ✅ Add dependencies to Cargo.toml
- ✅ Explain each dependency's purpose
- ✅ Learn about Cargo features

### Step 2: Error Handling Foundation ✅ COMPLETED
- ✅ Create custom error types with `thiserror`
- ✅ Learn about `Result<T, E>` and `?` operator
- ✅ Understand error propagation patterns

### Step 3: Basic CLI Structure ✅ COMPLETED
- ✅ Use `clap` derive macros for CLI
- ✅ Learn about derive macros and attributes
- ✅ Understand command-line argument parsing
- ✅ Implement verb-noun command format

### Step 4: Configuration System ✅ COMPLETED
- ✅ Create TOML-based config with `serde`
- ✅ Learn about serialization/deserialization
- ✅ Understand file I/O patterns
- ✅ Multi-location config file lookup (Linux + macOS styles)

### Step 5: Core Data Types ✅ COMPLETED
- ✅ Define Session and related structs
- ✅ Learn about ownership, lifetimes, and borrowing
- ✅ Practice with String vs &str
- ✅ Understand tagged unions (enums) vs C unions

### Step 6: Traits for Extensibility 🔄 IN PROGRESS
- Define TerminalBackend and WindowManagerBackend traits
- Learn about trait objects and dynamic dispatch
- Understand abstract interfaces in Rust

### Step 7: Project Discovery
- Use `ignore` crate for file discovery
- Learn about iterators and functional programming
- Practice with Vec<T> and Option<T>

### Step 8: Fuzzy Selection
- Integrate `skim` for interactive selection
- Learn about external crate integration
- Handle user input and cancellation

### Step 9: Async Programming
- Implement async functions for process spawning
- Learn about async/await, Future trait
- Use `tokio::process::Command`

### Step 10: Backend Implementations
- Implement Kitty and Aerospace backends
- Learn about pattern matching with `match`
- Practice error handling in real scenarios

I'll explain each Rust concept as we encounter it, making this both a practical project and a comprehensive Rust learning experience.

## Project Structure
```
src/
├── main.rs                 # CLI entry point
├── lib.rs                  # Library root
├── cli.rs                  # Clap-based CLI definitions
├── config.rs               # Configuration management
├── error.rs                # Custom error types
├── session/
│   ├── mod.rs
│   ├── manager.rs          # Core session orchestration
│   ├── types.rs            # Session data structures
│   └── discovery.rs        # Project discovery logic
├── backends/
│   ├── mod.rs              # Backend trait definitions
│   ├── terminal/
│   │   ├── mod.rs
│   │   └── kitty.rs        # Kitty terminal backend
│   └── window_manager/
│       ├── mod.rs
│       └── aerospace.rs    # Aerospace WM backend
└── utils/
    ├── mod.rs
    ├── path.rs             # Path abbreviation utilities
    └── process.rs          # Process execution helpers
```

## Dependencies to Add
```toml
clap = { version = "4.5", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
anyhow = "1.0"
thiserror = "1.0"
serde = { version = "1.0", features = ["derive"] }
toml = "0.8"
dirs = "5.0"
```