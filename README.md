# prefix-temurin-jre

A **rattler-build** recipe for repackaging the official Eclipse Temurin JRE pre-built binaries into a cross-platform `conda`/`pixi` package, published to [prefix.dev](https://prefix.dev).

> **Note:** This is a personal repackaging. Unlike [conda-forge](https://conda-forge.org), which requires building from source, this recipe directly downloads the official Adoptium binaries. This approach was rejected from conda-forge (see [staged-recipes#29085](https://github.com/conda-forge/staged-recipes/pull/29085)) but is perfectly valid for a private/personal channel.

## Quick Start

1. Replace `<CHANNEL>` in `.github/workflows/publish.yml` with your prefix.dev channel name.
2. (Optional) Update `context.version` and `context.build_number` in `recipe/recipe.yaml` to match a newer Temurin release.
3. Create a GitHub Release to trigger the publish workflow.

## Supported Platforms

- `linux-64` (x86_64)
- `linux-aarch64`
- `osx-64` (x86_64)
- `osx-arm64`
- `win-64`

## Local Build

Install `rattler-build` (e.g. via `pixi global install rattler-build`), then:

```bash
rattler-build build --recipe recipe/recipe.yaml
```

Packages will appear in `output/`.

## Setup Trusted Publishing (OIDC)

1. Go to your channel settings on [prefix.dev](https://prefix.dev).
2. Add a **Trusted Publisher** pointing to this repository.
3. The workflow already has `id-token: write` permissions.
