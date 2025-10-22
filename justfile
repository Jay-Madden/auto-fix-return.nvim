fmt:
    stylua lua/ --config-path=stylua.toml

fmt-check:
    stylua lua/ --check --config-path=stylua.toml

install-plenary:
    #!/bin/bash
    echo "===== Setting up Plenary.nvim ====="
    
    if [[ ! -d "testbin/plenary.nvim" ]] ; then
        git clone --depth 1 https://github.com/nvim-lua/plenary.nvim testbin/plenary.nvim
        echo "Plenary.nvim cloned successfully"
    else
        echo "Plenary.nvim already installed"
    fi

install-ts-parser:
    #!/bin/bash
    set -euxo pipefail
    echo "===== Setting up Go TreeSitter Parser ====="

    PARSER_REV="5e73f476efafe5c768eda19bbe877f188ded6144"
    PARSER_DIR="testbin/tree-sitter-go"
    PARSERS_DIR="testbin/parser"
    PARSER_INFO_DIR="testbin/parser-info"

    # Create directories
    mkdir -p "$PARSERS_DIR"
    mkdir -p "$PARSER_INFO_DIR"

    # Check if parser already exists and is correct version
    if [[ -f "$PARSERS_DIR/go.so" && -f "$PARSER_INFO_DIR/go.revision" ]]; then
        CURRENT_REV=$(cat "$PARSER_INFO_DIR/go.revision" | tr -d '"' | tr -d '\n')
        if [[ "$CURRENT_REV" == "$PARSER_REV" ]]; then
            echo "Go parser already built at correct revision: $PARSER_REV"
            exit 0
        fi
    fi

    # Check for tree-sitter CLI
    if ! command -v tree-sitter &> /dev/null; then
        echo "Error: tree-sitter CLI not found. Install with:"
        echo "  npm install -g tree-sitter-cli"
        echo "  or cargo install tree-sitter-cli"
        exit 1
    fi

    # Clone or update tree-sitter-go
    if [[ ! -d "$PARSER_DIR" ]]; then
        git clone https://github.com/tree-sitter/tree-sitter-go.git "$PARSER_DIR"
    fi

    cd "$PARSER_DIR"
    git reset --hard "$PARSER_REV"

    # Generate and compile the parser
    tree-sitter generate
    tree-sitter build --output "../parser/go.so"
    cd ../..

    # Create parser info file
    echo "\"$PARSER_REV\"" > "$PARSER_INFO_DIR/go.revision"

    echo "Go parser compiled successfully at revision: $PARSER_REV"

test: install-plenary install-ts-parser
    #!/bin/bash
    echo "===== Running Tests ====="
    nvim --headless -u scripts/minimal_init.lua -c "PlenaryBustedDirectory lua/test/"
