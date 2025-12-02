# Advent of Code 2025

Solutions for Advent of Code 2025 in [Janet](https://janet-lang.org).

## Setup

This project uses [Nix](https://nixos.org) for development setup:

```bash
direnv allow
```

Or manually:
```bash
nix-shell
```

## Quick Start

Run example solution:
```bash
just example 2
```

Run with actual input:
```bash
just run 2
```

Benchmark:
```bash
just bench 2
```

## Create New Day

```bash
just new N
```

This creates `dayN.janet`, `inputs/N.txt`, and `examples/N.txt`.

All available commands:
```bash
just
```
