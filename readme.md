# Neovim Configuration Setup

This repository contains my personal Neovim configuration, utilizing plugins and customizations for a modern workflow.

> [!WARNING]
> **Strict Requirement:** This configuration is designed for **Neovim 0.12** and newer.

## Prerequisites

Before installing, ensure your Linux system has the following software installed:

- **Neovim 0.12+**
- `ripgrep` (for fast searching)
- `composer` (for PHP dependencies)
- `lazygit` (for git management)
- `tree-sitter-cli` (for syntax parsing)
- `npm` (Required, but I use `bun` to fulfill this)

### The NPM -> Bun Alias

This configuration expects `npm` to be available on the path. I prefer to use **Bun** to handle this. You must alias `npm` to `bun` on your system for language servers to install correctly.

Run this command to create the necessary symlink (Reference: [Gist](https://gist.github.com/realpoke/2610a0fb43916aa04559b0df30bfc3f2)):

```bash
sudo ln -s "$(which bun)" /usr/local/bin/npm

```

## Installation

1. **Clone the repository**:
```bash
git clone git@github.com:realpoke/config.nvim.git ~/.config/nvim

```

2. **First Boot**:
Launch Neovim. The package manager will automatically bootstrap and install plugins.
```bash
nvim

```

---

**Note**: This configuration is intended solely for **Linux**.

