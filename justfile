parser_revisions := "2346a3ab1bb3857b48b29d779a1ef9799a248cd7 5e73f476efafe5c768eda19bbe877f188ded6144"

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

    PARSER_DIR="testbin/tree-sitter-go"
    PARSERS_DIR="testbin/parser"
    PARSER_INFO_DIR="testbin/parser-info"

    mkdir -p "$PARSERS_DIR"
    mkdir -p "$PARSER_INFO_DIR"

    if ! command -v tree-sitter &> /dev/null; then
        echo "Error: tree-sitter CLI not found. Install with:"
        echo "  npm install -g tree-sitter-cli"
        echo "  or cargo install tree-sitter-cli"
        exit 1
    fi

    if [[ ! -d "$PARSER_DIR" ]]; then
        git clone https://github.com/tree-sitter/tree-sitter-go.git "$PARSER_DIR"
    fi

    for PARSER_REV in {{parser_revisions}}; do
        echo "===== Setting up Go TreeSitter Parser at $PARSER_REV ====="

        PARSER_OUTPUT="$PARSERS_DIR/go-${PARSER_REV}.so"
        PARSER_INFO_FILE="$PARSER_INFO_DIR/go-${PARSER_REV}.revision"

        # Check if parser already exists and is correct version
        if [[ -f "$PARSER_OUTPUT" && -f "$PARSER_INFO_FILE" ]]; then
            CURRENT_REV=$(cat "$PARSER_INFO_FILE" | tr -d '"' | tr -d '\n')
            if [[ "$CURRENT_REV" == "$PARSER_REV" ]]; then
                echo "Go parser already built at correct revision: $PARSER_REV"
                continue
            fi
        fi

        cd "$PARSER_DIR"
        git reset --hard "$PARSER_REV"

        tree-sitter generate
        tree-sitter build --output "../parser/go-${PARSER_REV}.so"
        cd ../..

        echo "\"$PARSER_REV\"" > "$PARSER_INFO_FILE"

        echo "Go parser compiled successfully at revision: $PARSER_REV"
    done

test: install-plenary install-ts-parser
    #!/bin/bash
    set -euxo pipefail

    PARSERS_DIR="testbin/parser"

    for PARSER_REV in {{parser_revisions}}; do
        echo "===== Running Tests against Parser $PARSER_REV ====="

        # Copy the specific parser version to go.so
        cp "$PARSERS_DIR/go-${PARSER_REV}.so" "$PARSERS_DIR/go.so"

        # Run tests
        nvim --headless -u scripts/minimal_init.lua -c "PlenaryBustedDirectory lua/test/"

        echo "===== Tests completed for Parser $PARSER_REV ====="
    done
