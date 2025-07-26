# termd

termd is a program that manages your terminal windows as sessions. 
You can register a list of directories (like a git repository) and 
open a session for each one of them, switch between them by fuzzy finding them.

# Why?

I use Neovim as my primary editor. I usually work with multiple git repositories 
and switch between them from time to time. I mainly switched from VSCode/Zed few years
back because, I liked how `tmux` and `vim` worked well to solve this issue.

I primarily use macOS since I am a single laptop person and want to keep both work and
personal in the same laptop. As my work environment demands a Mac (or may be I am reluctant
to convince or get a linux system at work), so I finally made up my mind that I have to make my life on macOS 
as easy (or possibly as close to being easy) as those folks who live in the linux world
(like @primeagen, @mitchelh, @dhh etc.,). 

I started off with iTerm2 terminal in macOS years back. It is a good one, but I wanted a declarive
config to be checked into my [dotfiles](https://github.com/msharran/aincrad). So, I tried 
few GPU based faster alternatives and finally started using Kitty (I won't get into why I chose this now, may be a
story for later, if at all anybody is interested). 

I was using Kitty + Neovim + Tmux. But, doing so I have lost kitty's amazing features like shell integration,
`ctrl+shift+g = show last output in less`, etc., which I found very useful since I deal with a lot of logs
at work. I was using @primeagen's *tmux-sessionizer* script for creating, fuzzy finding and switching between 
my git projects laid out as tmux sessions.

To get out of tmux (to exploit kitty's full feature set), I wrote a script called [`kitty-sessionizer`](./examples/kitty-sessioniser.sh) using 
kitty's CLI and `aerospace` CLI (my macOS window manager - like i3wm for linux). This worked, but I want it to
work for any feature rich terminal emulator (like Ghostty or anything new) and any window manager. 

# How it works

> [!NOTE]
> For the sake of this example, I will be using 
> - `kitty` as the terminal emulator,
> - `aerospace` as the macOS window manager.

1. Run the following command to start a fuzzy finder on your list of 
projects

```bash
$ termd change-session --create --interactive
```

- config file: with project directory patterns, absolute path etc.,
- start termd (in shell profile) if not started already. Determine this using
deterministic unix domain sockets (light weight daemon like tmux)
