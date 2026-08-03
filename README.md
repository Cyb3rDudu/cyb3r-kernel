# cyb3r-kernel

Custom Asahi Linux kernel builds with patches for Apple Silicon MacBooks.

## Patches

| Patch | Description |
|---|---|
| `asahi-nightlight.patch` | GNOME Night Light support (DCP gamma LUT from BuenGenio/asahi-m2-nightlight) |
| `0001-agx-show-fdinfo-memory-stats.patch` | AGX GPU fdinfo telemetry (utilization, power, temp, freq via firmware stats) |

## Build locally

```bash
nix build --impure --expr '
  { pkgs ? import <nixpkgs> {} }:
  pkgs.buildLinux {
    src = ./.;
    version = "7.1.5";
    modDirVersion = "7.1.5";
    kernelPatches = [
      { name = "nightlight"; patch = ./patches/asahi-nightlight.patch; }
      { name = "agx-fdinfo";  patch = ./patches/0001-agx-show-fdinfo-memory-stats.patch; }
    ];
    structuredExtraConfig = with lib.kernel; {
      ARM64_16K_PAGES = yes;
      DRM_ASAHI = module;
      RUST_DRM_SCHED = yes;
    };
    features.rust = true;
  }
'
```

## CI

GitHub Actions on self-hosted ARM64 runner. Trigger manually with a release tag.
