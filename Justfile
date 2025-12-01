set shell := ["bash", "-c"]

janet_libpath :=  `pkg-config --libs-only-L janet | cut -c 3-`

# Show available commands
@default:
    just --list

# Run day N with example input
example day:
    janet day{{ day }}.janet examples/{{ day }}.txt

# Run day N with actual input
run day:
    janet day{{ day }}.janet inputs/{{ day }}.txt

# Run all days with actual input
run-all:
    #!/usr/bin/env bash
    set -euo pipefail
    ls -1 day*.janet | cut -d. -f1 | cut -c4- | xargs just run

# Benchmark day N
bench day compiled="0":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{ compiled }}" != "0" ]; then
        just build
        cmd="./build/day{{ day }} inputs/{{ day }}.txt"
    else
        cmd="janet day{{ day }}.janet inputs/{{ day }}.txt"
    fi
    hyperfine --warmup 25 -N "$cmd"

# Benchmark all days
bench-all compiled="0":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{ compiled }}" != "0" ]; then
        just build
        ls -1 day*.janet \
          | cut -d. -f1 \
          | cut -c4- \
          | xargs -I {} bash -c 'hyperfine --warmup 25 -N "./build/day{} inputs/{}.txt"'
    else
        ls -1 day*.janet \
          | cut -d. -f1 \
          | cut -c4- \
          | xargs -I {} bash -c 'hyperfine --warmup 25 -N "janet day{}.janet inputs/{}.txt"'
    fi

# Format day N
fmt day:
    cljfmt fix day{{ day }}.janet

# Format all solution files
fmt-all:
    cljfmt fix day*.janet

# Build all executables
build:
    JANET_LIBPATH={{ janet_libpath }} jpm build

# Run day N executable with example input
example-exec day: build
    ./build/day{{ day }} examples/{{ day }}.txt

# Run day N executable with actual input
run-exec day: build
    ./build/day{{ day }} inputs/{{ day }}.txt

# Clean build artifacts
clean:
    jpm clean
    rm -f day*.jimage

# Open Janet REPL
repl:
    janet
