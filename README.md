# cyb3r-kernel

Custom Asahi Linux kernel builds with patches for Apple Silicon MacBooks.

## Patches

| File | Description |
|---|---|
| `asahi-nightlight.patch` | GNOME Night Light (DCP gamma LUT) |
| `0001-agx-show-fdinfo-memory-stats.patch` | AGX GPU fdinfo telemetry (util, power, temp, freq via firmware stats) |

## CI

GitHub Actions triggers on `workflow_dispatch` with a release tag. Builds using Nix (cross-compiled for aarch64 with Rust). Artifact: `kernel-<tag>-arm64.tar.gz`.

## Local development (carrier/mothership)

The kernel is built as part of the NixOS flake. CI here is for tracking Asahi releases only.

## Usage

```bash
# Trigger a build for a specific Asahi release:
gh workflow run build.yml -f tag=asahi-7.1.5-1
```

Or use the bundled flake locally:

```bash
nix build .#packages.aarch64-linux.default
```
