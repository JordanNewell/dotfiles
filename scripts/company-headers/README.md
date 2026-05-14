# Company Headers Toolkit

**Anything XYZ** - Standardized copyright/license headers across all projects.

## Quick Start

```bash
cd /path/to/your/project
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh
```

## Directory Structure

```
company-headers/
├── templates/
│   ├── python.txt       # # comments
│   ├── javascript.txt   # /** */ block
│   ├── shell.txt        # # comments
│   ├── go.txt           # // comments
│   ├── rust.txt         # // comments (NEW!)
│   ├── sql.txt          # -- comments (NEW!)
│   ├── yaml.txt         # # comments (NEW!)
│   └── dockerfile.txt   # # comments (NEW!)
├── apply-headers.sh     # Main script
├── detect-metadata.sh   # Auto-detects project info
├── setup-hooks.sh      # Install pre-commit hooks (NEW!)
├── pre-commit.sh       # Pre-commit hook (NEW!)
├── symlink-setup.sh   # Add symlink to any repo
├── config.json        # Per-project overrides (NEW!)
├── ci-workflow.yml    # CI/CD template (NEW!)
└── README.md
```

## Usage

```bash
# Apply headers to all files
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh

# Dry run (preview changes)
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh --dry-run

# Check for missing headers (CI mode)
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh --check

# Target specific directory
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh --path src/

# Verbose output
bash ~/dev/projects/dotfiles/scripts/company-headers/apply-headers.sh --verbose
```

## How It Works

### 1. Auto-Detection Priority

The script detects project metadata from (in priority order):

| Source | Fields |
|--------|---------|
| `package.json` | `name`, `description` |
| `pyproject.toml` | `name`, `description` |
| `Cargo.toml` | `name`, `description` |
| `go.mod` | `module` |
| **Directory name** | Fallback (config lookup) |

### 2. Template Variables

Templates support variable substitution:

| Variable | Value |
|----------|-------|
| `{{YEAR}}` | Current year (e.g., 2026) |
| `{{COMPANY}}` | Anything XYZ |
| `{{AUTHOR}}` | Auto-detected from `git config user.name` |
| `{{EMAIL}}` | Auto-detected from `git config user.email` |
| `{{PRODUCT}}` | Auto-detected or overridden via config.json |
| `{{PROJECT}}` | Project name |

### 3. Author Configuration

Author info is auto-detected from git config:

```bash
# View current config
git config user.name    # → dev23xyz-oss
git config user.email   # → dev.23.xyz@gmail.com

# Update if needed
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Configuration

Override per-project settings in `config.json`:

```json
{
  "defaults": {
    "company": "Anything XYZ",
    "author": null,  // Auto-detect from git
    "email": null,      // Auto-detect from git
    "license": "LicenseRef-AnythingXYZ-Proprietary"
  },
  "projects": {
    "molana": {
      "product": "Curtis Trade AI Solana Edition",
      "override": "Molana Trading Ecosystem"
    },
    "m0l-handz": {
      "product": "Social Trading Platform"
    },
    "my-app": {
      "product": "My Custom Product Name"
    }
  }
}
```

**Note**: Config lookup uses directory name as fallback, so `molana` directory will match even if `pyproject.toml` has `name = "mcp-solana"`.

## Supported File Types

| Extension | Template | Comment Style |
|-----------|----------|---------------|
| `.py`, `.pyi` | python | `#` |
| `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`, `.cjs` | javascript | `/** */` |
| `.sh`, `.bash`, `.zsh` | shell | `#` |
| `.go`, `.mod` | go | `//` |
| `.rs` | rust | `//` (NEW!) |
| `.sql` | sql | `--` (NEW!) |
| `.yml`, `.yaml` | yaml | `#` (NEW!) |
| `Dockerfile*` | dockerfile | `#` (NEW!) |

## Excluded Paths

Files in these paths are automatically excluded:

- `node_modules/`
- `vendor/`
- `__pycache__/`
- `.venv/`, `venv/`
- `build/`, `dist/`
- `.git/`
- `.pytest_cache/`
- `.ruff_cache/`
- `.mypy_cache/`

## Integration Options

### Option 1: Pre-commit Hook (Local)

```bash
# Install to current repository
cd /path/to/project
bash ~/dev/projects/dotfiles/scripts/company-headers/setup-hooks.sh --local
```

### Option 2: Pre-commit Hook (Global)

```bash
# Install to global git template
bash ~/dev/projects/dotfiles/scripts/company-headers/setup-hooks.sh --global

# Then run in each repo:
git init  # Re-runs init to apply template
```

### Option 3: Symlink (Recommended)

```bash
cd /path/to/project
bash ~/dev/projects/dotfiles/scripts/company-headers/symlink-setup.sh
```

Creates `scripts/company-headers` symlink → use from anywhere in the project:

```bash
bash scripts/company-headers/apply-headers.sh
```

### Option 4: Makefile

Add to your `Makefile`:

```makefile
.PHONY: headers headers-check

headers:
	@echo "Applying company headers..."
	@bash scripts/company-headers/apply-headers.sh

headers-check:
	@echo "Checking company headers..."
	@bash scripts/company-headers/apply-headers.sh --check
```

## CI/CD Integration

### GitHub Actions

Copy `ci-workflow.yml` to `.github/workflows/company-headers.yml`:

```bash
cp ~/dev/projects/dotfiles/scripts/company-headers/ci-workflow.yml \
   /path/to/project/.github/workflows/company-headers.yml
```

The workflow will check headers on every push/PR to main branches.

## Adding New Templates

1. Create `templates/<language>.txt`
2. Add mapping to `TEMPLATE_MAP` in `apply-headers.sh`
3. Use variables: `{{YEAR}}`, `{{COMPANY}}`, `{{AUTHOR}}`, `{{PRODUCT}}`, `{{PROJECT}}`

Example `templates/rust.txt`:

```rust
//
// SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
// Copyright (c) {{YEAR}} {{COMPANY}}
// Author: {{AUTHOR}}
// Company: {{COMPANY}}
// Product: {{PRODUCT}}
//
```

Then add to `apply-headers.sh`:

```bash
declare -A TEMPLATE_MAP=(
    ...
    ["rs"]="rust"
)
```

## License

SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
Copyright (c) 2026 Anything XYZ
