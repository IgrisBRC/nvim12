#!/bin/bash

TARGET_DIR="$HOME/.local/share/nvim/site/parser"
TEMP_DIR="/tmp/nvim-parsers-build"

rm -rf "$TEMP_DIR"
mkdir -p "$TARGET_DIR"
mkdir -p "$TEMP_DIR"

LANGS=(
    "c|https://github.com/tree-sitter/tree-sitter-c|"
    "rust|https://github.com/tree-sitter/tree-sitter-rust|"
    "go|https://github.com/tree-sitter/tree-sitter-go|"
    "bash|https://github.com/tree-sitter/tree-sitter-bash|"
    "lua|https://github.com/tree-sitter-grammars/tree-sitter-lua|"
    "javascript|https://github.com/tree-sitter/tree-sitter-javascript|"
    "typescript|https://github.com/tree-sitter/tree-sitter-typescript|typescript"
    "tsx|https://github.com/tree-sitter/tree-sitter-typescript|tsx"
    "css|https://github.com/tree-sitter/tree-sitter-css|"
    "html|https://github.com/tree-sitter/tree-sitter-html|"
)

for entry in "${LANGS[@]}"; do
    IFS='|' read -r lang url subdir <<< "$entry"

    echo "Processing $lang..."
    REPO_DIR="$TEMP_DIR/repo-$lang"
    export GIT_TERMINAL_PROMPT=0

    # Clone Logic
    if ! git clone --depth 1 "$url" "$REPO_DIR" --quiet; then
        echo "✗ Primary URL failed for $lang, trying fallback..."
        FALLBACK_URL=$(echo "$url" | sed 's/tree-sitter\//tree-sitter-grammars\//')
        if ! git clone --depth 1 "$FALLBACK_URL" "$REPO_DIR" --quiet; then
            echo "!! Critical failure for $lang. Skipping."
            continue
        fi
    fi

    # Enter Build Directory
    if [ -n "$subdir" ]; then cd "$REPO_DIR/$subdir"; else cd "$REPO_DIR"; fi

    # Compiler Detection
    SRC_FILES="src/parser.c"
    COMPILER="gcc"
    if [ -f "src/scanner.cc" ]; then
        SRC_FILES="$SRC_FILES src/scanner.cc"
        COMPILER="g++"
    elif [ -f "src/scanner.c" ]; then
        SRC_FILES="$SRC_FILES src/scanner.c"
    fi

    # Compile and Move
    $COMPILER -o "$lang.so" -Isrc $SRC_FILES -shared -fPIC -O3
    mv "$lang.so" "$TARGET_DIR/$lang.so"
    echo "✓ $lang .so ready."

    # Query Management
    QUERY_DIR="$HOME/.local/share/nvim/site/queries/$lang"
    mkdir -p "$QUERY_DIR"
    cp "$REPO_DIR"/queries/*.scm "$QUERY_DIR/" 2>/dev/null
    cp ./queries/*.scm "$QUERY_DIR/" 2>/dev/null
    
    echo "✓ $lang queries synced."
done

# Final check for the sh/bash relationship
if [ -f "$TARGET_DIR/bash.so" ] && [ ! -f "$TARGET_DIR/sh.so" ]; then
    # We DON'T copy the .so (to avoid symbol errors), 
    # but we DO need the queries for 'sh' filetype to work.
    mkdir -p "$HOME/.local/share/nvim/site/queries/sh"
    cp "$HOME/.local/share/nvim/site/queries/bash/"*.scm "$HOME/.local/share/nvim/site/queries/sh/" 2>/dev/null
    echo "✓ sh queries aliased from bash."
fi
