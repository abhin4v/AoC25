# Advent of Code 2025

Solutions for [Advent of Code 2025](https://adventofcode.com/2025) in [Janet](https://janet-lang.org).

## Setup

This project uses [Nix](https://nixos.org) for development setup.

Use [`direnv`](https://direnv.net/):

```bash
echo "use nix" > .envrc
direnv allow
```

Or start Nix shell manually:
```bash
nix-shell
```

## Quick Start

This project uses [`just`](https://just.systems) as a command runner.

Run example solution:
```bash
just example 2
```

Run with actual input:
```bash
just run 2
```

Run tests for day N:
```bash
just test 2
```

Open Janet REPL for day N:
```bash
just repl 2
```

Benchmark:
```bash
just bench 2
```

Create new solution:
```bash
just new N
```

This creates `dayN.janet`, `inputs/N.txt`, `examples/N.txt`, and `test/dayN.janet`.

List all available commands:
```bash
just
```
