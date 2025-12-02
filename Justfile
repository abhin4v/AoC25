set shell := ["bash", "-c"]

janet_libpath := `pkg-config --libs-only-L janet | cut -c 3-`

# Show available commands
@default:
    just --list

# Create a new day file with template
new day:
    #!/usr/bin/env bash
    set -euo pipefail
    d="{{ day }}"
    if [ -f "day${d}.janet" ]; then
        echo "day${d}.janet already exists"
        exit 1
    fi
    cp _template.janet "day${d}.janet"
    sed -i.bak "s/dayN/day${d}/g" "day${d}.janet"
    rm -f "day${d}.janet.bak"
    touch "inputs/${d}.txt"
    touch "examples/${d}.txt"
    echo "" >> project.janet
    echo "(declare-executable" >> project.janet
    echo "  :name \"day${d}\"" >> project.janet
    echo "  :entry \"day${d}.janet\")" >> project.janet
    echo "Created day${d}.janet, inputs/${d}.txt, examples/${d}.txt, and project.janet entry"

# Run day N with example input
example day:
    AOC_INPUT_PATH=examples janet day{{ day }}.janet

# Run day N with actual input
run day:
    AOC_INPUT_PATH=inputs janet day{{ day }}.janet

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
        just build inputs
        cmd="./build/day{{ day }}"
    else
        cmd="janet day{{ day }}.janet"
    fi
    AOC_INPUT_PATH=inputs hyperfine --warmup 25 -N "$cmd"

# Benchmark all days
bench-all compiled="0":
    #!/usr/bin/env bash
    set -euo pipefail
    export AOC_INPUT_PATH=inputs
    if [ "{{ compiled }}" != "0" ]; then
        just build inputs
        ls -1 day*.janet \
          | cut -d. -f1 \
          | cut -c4- \
          | xargs -I {} bash -c 'hyperfine --warmup 25 -N "./build/day{}"'
    else
        ls -1 day*.janet \
          | cut -d. -f1 \
          | cut -c4- \
          | xargs -I {} bash -c 'hyperfine --warmup 25 -N "janet day{}.janet"'
    fi

# Format day N
fmt day:
    cljfmt fix day{{ day }}.janet

# Format all solution files
fmt-all:
    cljfmt fix day*.janet

# Build all executables
build path:
    AOC_INPUT_PATH={{ path }} JANET_LIBPATH={{ janet_libpath }} jpm build

# Run day N executable with example input
example-exec day: (build "examples")
    AOC_INPUT_PATH=examples ./build/day{{ day }}

# Run day N executable with actual input
run-exec day: (build "inputs")
    AOC_INPUT_PATH=inputs ./build/day{{ day }}

# Clean build artifacts
clean:
    jpm clean
    rm -f day*.jimage

# Open Janet REPL
repl:
    janet
