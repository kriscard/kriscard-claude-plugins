#!/usr/bin/env bash
# Project Structure Analyzer
# Detects project stack and suggests CLAUDE.md improvements

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Target directory (default: current)
PROJECT_DIR="${1:-.}"
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)

echo -e "${BLUE}Project Structure Analyzer${NC}" >&2
echo -e "${BLUE}==========================${NC}" >&2
echo -e "Analyzing: ${PROJECT_DIR}" >&2
echo "" >&2

# Initialize detection results
declare -A DETECTED
SUGGESTIONS=()

# Check for existing CLAUDE.md
HAS_CLAUDE_MD="false"
if [[ -f "$PROJECT_DIR/CLAUDE.md" ]] || [[ -f "$PROJECT_DIR/.claude/CLAUDE.md" ]]; then
    HAS_CLAUDE_MD="true"
fi

# Detect package manager
detect_package_manager() {
    if [[ -f "$PROJECT_DIR/pnpm-lock.yaml" ]]; then
        DETECTED[package_manager]="pnpm"
    elif [[ -f "$PROJECT_DIR/yarn.lock" ]]; then
        DETECTED[package_manager]="yarn"
    elif [[ -f "$PROJECT_DIR/package-lock.json" ]]; then
        DETECTED[package_manager]="npm"
    elif [[ -f "$PROJECT_DIR/bun.lockb" ]]; then
        DETECTED[package_manager]="bun"
    elif [[ -f "$PROJECT_DIR/Cargo.toml" ]]; then
        DETECTED[package_manager]="cargo"
    elif [[ -f "$PROJECT_DIR/go.mod" ]]; then
        DETECTED[package_manager]="go"
    elif [[ -f "$PROJECT_DIR/pyproject.toml" ]]; then
        DETECTED[package_manager]="poetry"
    elif [[ -f "$PROJECT_DIR/requirements.txt" ]]; then
        DETECTED[package_manager]="pip"
    elif [[ -f "$PROJECT_DIR/Gemfile" ]]; then
        DETECTED[package_manager]="bundler"
    fi

    if [[ -n "${DETECTED[package_manager]:-}" ]]; then
        SUGGESTIONS+=("Document ${DETECTED[package_manager]} commands in CLAUDE.md")
    fi
}

# Detect framework
detect_framework() {
    if [[ -f "$PROJECT_DIR/package.json" ]]; then
        local deps
        deps=$(cat "$PROJECT_DIR/package.json")

        # Next.js
        if echo "$deps" | grep -q '"next"'; then
            DETECTED[framework]="nextjs"
            SUGGESTIONS+=("Document Next.js App Router vs Pages Router usage")
        # React
        elif echo "$deps" | grep -q '"react"'; then
            DETECTED[framework]="react"
            SUGGESTIONS+=("Document React component patterns and state management")
        # Vue
        elif echo "$deps" | grep -q '"vue"'; then
            DETECTED[framework]="vue"
            SUGGESTIONS+=("Document Vue composition API usage")
        # Angular
        elif echo "$deps" | grep -q '"@angular/core"'; then
            DETECTED[framework]="angular"
            SUGGESTIONS+=("Document Angular module structure")
        # Express
        elif echo "$deps" | grep -q '"express"'; then
            DETECTED[framework]="express"
            SUGGESTIONS+=("Document API routes and middleware")
        # Fastify
        elif echo "$deps" | grep -q '"fastify"'; then
            DETECTED[framework]="fastify"
            SUGGESTIONS+=("Document Fastify plugins and routes")
        # NestJS
        elif echo "$deps" | grep -q '"@nestjs/core"'; then
            DETECTED[framework]="nestjs"
            SUGGESTIONS+=("Document NestJS modules and services")
        fi
    elif [[ -f "$PROJECT_DIR/pyproject.toml" ]] || [[ -f "$PROJECT_DIR/requirements.txt" ]]; then
        local deps=""
        [[ -f "$PROJECT_DIR/pyproject.toml" ]] && deps=$(cat "$PROJECT_DIR/pyproject.toml")
        [[ -f "$PROJECT_DIR/requirements.txt" ]] && deps="$deps $(cat "$PROJECT_DIR/requirements.txt")"

        if echo "$deps" | grep -qi "django"; then
            DETECTED[framework]="django"
            SUGGESTIONS+=("Document Django apps and models")
        elif echo "$deps" | grep -qi "flask"; then
            DETECTED[framework]="flask"
            SUGGESTIONS+=("Document Flask blueprints and routes")
        elif echo "$deps" | grep -qi "fastapi"; then
            DETECTED[framework]="fastapi"
            SUGGESTIONS+=("Document FastAPI routers and dependencies")
        fi
    fi
}

# Detect testing framework
detect_testing() {
    if [[ -f "$PROJECT_DIR/package.json" ]]; then
        local pkg
        pkg=$(cat "$PROJECT_DIR/package.json")

        if echo "$pkg" | grep -q '"vitest"'; then
            DETECTED[testing]="vitest"
        elif echo "$pkg" | grep -q '"jest"'; then
            DETECTED[testing]="jest"
        elif echo "$pkg" | grep -q '"mocha"'; then
            DETECTED[testing]="mocha"
        elif echo "$pkg" | grep -q '"playwright"'; then
            DETECTED[testing]="playwright"
        elif echo "$pkg" | grep -q '"cypress"'; then
            DETECTED[testing]="cypress"
        fi
    elif [[ -f "$PROJECT_DIR/pyproject.toml" ]] || [[ -d "$PROJECT_DIR/tests" ]]; then
        if grep -q "pytest" "$PROJECT_DIR/pyproject.toml" 2>/dev/null || [[ -f "$PROJECT_DIR/pytest.ini" ]]; then
            DETECTED[testing]="pytest"
        fi
    elif [[ -f "$PROJECT_DIR/Cargo.toml" ]]; then
        DETECTED[testing]="cargo-test"
    elif [[ -f "$PROJECT_DIR/go.mod" ]]; then
        DETECTED[testing]="go-test"
    fi

    if [[ -n "${DETECTED[testing]:-}" ]]; then
        SUGGESTIONS+=("Document test commands: how to run unit/integration/e2e tests")
    fi
}

# Detect TypeScript
detect_typescript() {
    if [[ -f "$PROJECT_DIR/tsconfig.json" ]]; then
        DETECTED[typescript]="true"

        # Check for strict mode
        if grep -q '"strict":\s*true' "$PROJECT_DIR/tsconfig.json" 2>/dev/null; then
            DETECTED[typescript_strict]="true"
        fi

        SUGGESTIONS+=("Document TypeScript configuration and type patterns")
    fi
}

# Detect CI/CD
detect_ci() {
    if [[ -d "$PROJECT_DIR/.github/workflows" ]]; then
        DETECTED[ci]="github-actions"
        SUGGESTIONS+=("Document CI/CD pipeline and deployment process")
    elif [[ -f "$PROJECT_DIR/.gitlab-ci.yml" ]]; then
        DETECTED[ci]="gitlab-ci"
        SUGGESTIONS+=("Document GitLab CI pipeline")
    elif [[ -f "$PROJECT_DIR/.circleci/config.yml" ]]; then
        DETECTED[ci]="circleci"
        SUGGESTIONS+=("Document CircleCI workflow")
    elif [[ -f "$PROJECT_DIR/Jenkinsfile" ]]; then
        DETECTED[ci]="jenkins"
        SUGGESTIONS+=("Document Jenkins pipeline")
    fi
}

# Detect Docker
detect_docker() {
    if [[ -f "$PROJECT_DIR/Dockerfile" ]] || [[ -f "$PROJECT_DIR/docker-compose.yml" ]] || [[ -f "$PROJECT_DIR/docker-compose.yaml" ]]; then
        DETECTED[docker]="true"
        SUGGESTIONS+=("Document Docker commands and local development setup")
    fi
}

# Detect monorepo
detect_monorepo() {
    if [[ -f "$PROJECT_DIR/pnpm-workspace.yaml" ]]; then
        DETECTED[monorepo]="pnpm-workspaces"
    elif [[ -f "$PROJECT_DIR/lerna.json" ]]; then
        DETECTED[monorepo]="lerna"
    elif [[ -f "$PROJECT_DIR/nx.json" ]]; then
        DETECTED[monorepo]="nx"
    elif [[ -f "$PROJECT_DIR/turbo.json" ]]; then
        DETECTED[monorepo]="turborepo"
    fi

    if [[ -n "${DETECTED[monorepo]:-}" ]]; then
        SUGGESTIONS+=("Document monorepo structure and package relationships")
    fi
}

# Detect common directories
detect_structure() {
    local dirs=()
    [[ -d "$PROJECT_DIR/src" ]] && dirs+=("src")
    [[ -d "$PROJECT_DIR/lib" ]] && dirs+=("lib")
    [[ -d "$PROJECT_DIR/app" ]] && dirs+=("app")
    [[ -d "$PROJECT_DIR/pages" ]] && dirs+=("pages")
    [[ -d "$PROJECT_DIR/components" ]] && dirs+=("components")
    [[ -d "$PROJECT_DIR/tests" ]] && dirs+=("tests")
    [[ -d "$PROJECT_DIR/__tests__" ]] && dirs+=("__tests__")
    [[ -d "$PROJECT_DIR/e2e" ]] && dirs+=("e2e")
    [[ -d "$PROJECT_DIR/docs" ]] && dirs+=("docs")
    [[ -d "$PROJECT_DIR/scripts" ]] && dirs+=("scripts")
    [[ -d "$PROJECT_DIR/packages" ]] && dirs+=("packages")
    [[ -d "$PROJECT_DIR/apps" ]] && dirs+=("apps")

    if [[ ${#dirs[@]} -gt 0 ]]; then
        DETECTED[directories]=$(printf '%s,' "${dirs[@]}" | sed 's/,$//')
    fi
}

# Detect linting/formatting
detect_linting() {
    if [[ -f "$PROJECT_DIR/biome.json" ]] || [[ -f "$PROJECT_DIR/biome.jsonc" ]]; then
        DETECTED[linting]="biome"
    elif [[ -f "$PROJECT_DIR/.eslintrc.json" ]] || [[ -f "$PROJECT_DIR/.eslintrc.js" ]] || [[ -f "$PROJECT_DIR/eslint.config.js" ]]; then
        DETECTED[linting]="eslint"
    fi

    if [[ -f "$PROJECT_DIR/.prettierrc" ]] || [[ -f "$PROJECT_DIR/prettier.config.js" ]]; then
        DETECTED[formatting]="prettier"
    fi
}

# Run all detections
detect_package_manager
detect_framework
detect_testing
detect_typescript
detect_ci
detect_docker
detect_monorepo
detect_structure
detect_linting

# Build JSON output
build_detection_json() {
    local json="{"
    local first=true

    for key in "${!DETECTED[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            json+=","
        fi
        json+="\"$key\":\"${DETECTED[$key]}\""
    done

    json+="}"
    echo "$json"
}

# Build suggestions JSON
build_suggestions_json() {
    if [[ ${#SUGGESTIONS[@]} -eq 0 ]]; then
        echo "[]"
        return
    fi

    local json="["
    local first=true

    for suggestion in "${SUGGESTIONS[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            json+=","
        fi
        json+="\"$suggestion\""
    done

    json+="]"
    echo "$json"
}

# Output final JSON
detection_json=$(build_detection_json)
suggestions_json=$(build_suggestions_json)

jq -n \
    --arg project_dir "$PROJECT_DIR" \
    --arg has_claude_md "$HAS_CLAUDE_MD" \
    --argjson detected "$detection_json" \
    --argjson suggestions "$suggestions_json" \
    --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    '{
        metadata: {
            timestamp: $timestamp,
            project_dir: $project_dir,
            has_claude_md: ($has_claude_md == "true")
        },
        detected: $detected,
        suggestions: $suggestions
    }'

echo "" >&2
echo -e "${GREEN}Analysis complete${NC}" >&2
