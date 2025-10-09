#!/usr/bin/env bash
set -euo pipefail


# Usage: generate_completions.sh <outdir>
# <outdir> is the installation directory passed by the build process

outdir="$1"

# Create directories for bash and fish completions
mkdir -p "$outdir/share/bash-completion/completions"
mkdir -p "$outdir/share/fish/vendor_completions.d"

# Generate bash completions
register-python-argcomplete wftime > "$outdir/share/bash-completion/completions/wftime"
register-python-argcomplete urlq > "$outdir/share/bash-completion/completions/urlq"

# Generate fish completions
register-python-argcomplete --shell fish wftime > "$outdir/share/fish/vendor_completions.d/wftime.fish"
register-python-argcomplete --shell fish urlq > "$outdir/share/fish/vendor_completions.d/urlq.fish"