# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`termd` is a terminal session manager written in Rust that helps manage terminal windows as sessions. It allows users to register directories (like git repositories) and open/switch between sessions using fuzzy finding. The project aims to work with any terminal emulator and window manager, replacing tmux-based solutions while preserving terminal-specific features.

## Development Commands

- **Build**: `cargo build`
- **Run**: `cargo run`
- **Build (release)**: `cargo build --release`
- **Run with arguments**: `cargo run -- [args]`
- **Check code**: `cargo check`
- **Run tests**: `cargo test`

## Architecture

The project is currently in early development with a minimal Rust structure:
- `src/main.rs`: Entry point (currently just "Hello, world!")
- `examples/kitty-sessioniser.sh`: Reference implementation showing the desired functionality using Kitty terminal and Aerospace window manager

## Key Concepts

Based on the README and example script, the intended functionality includes:
- Session management similar to tmux-sessionizer but for native terminal windows
- Fuzzy finding of projects using configurable directory patterns
- Window detection and focus using window manager APIs
- Path abbreviation for clean session titles
- Support for multiple terminal emulators and window managers

## Current State

**Implementation Progress**: The project is following a step-by-step learning approach documented in `PLAN.md`. 

**Completed Components**:
- ✅ Error handling with custom `TermdError` types
- ✅ CLI structure using `clap` with verb-noun commands (`change-session`, `list-sessions`, `get-session`)
- ✅ TOML configuration system with multi-location lookup
- ✅ Core data types (`Session`, `SessionInfo`, `WindowInfo`, `WindowId`)

**Current Progress**: Step 6 - Traits for Extensibility (see `PLAN.md` for detailed progress)

## Implementation Plan

**IMPORTANT**: This project follows a structured learning plan documented in `PLAN.md`. Always check `PLAN.md` first to understand:
- What has been completed
- Current implementation step
- Next steps in the learning journey
- Specific Rust concepts being taught at each step

The plan ensures systematic learning of Rust concepts while building a practical terminal session manager.

## Dependencies

The project uses the following Rust crates:
- `clap` (4.5): CLI parsing with derive macros
- `tokio` (1.0): Async runtime for non-blocking I/O
- `thiserror` (1.0): Custom error types
- `anyhow` (1.0): Application-level error handling
- `serde` (1.0): Serialization/deserialization
- `toml` (0.8): TOML configuration parsing
- `dirs` (5.0): Cross-platform directory paths
- `skim` (0.10): Rust fuzzy finder alternative to fzf
- `ignore` (0.4): File finding library used by fd
- `grep` (0.3): Text searching library used by ripgrep

External tools still needed:
- Window manager CLI (e.g., `aerospace` for macOS)
- Terminal emulator CLI (e.g., `kitty`)

## Development Guidelines

- Follow latest Rust design patterns
- Refer to `PLAN.md` for current implementation status and next steps
- Each step teaches specific Rust concepts - maintain the learning progression