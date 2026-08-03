# cyb3r-kernel

Patched Asahi Linux kernel for Apple Silicon. CI tracks upstream releases and
produces pre-built kernel images.

## Patches

| # | File | Description |
|---|---|---|
| 0001 | `0001-agx-fdinfo-telemetry.patch` | AGX GPU fdinfo: utilization, power, temp, freq |
| 0100 | `0100-dcp-nightlight-gamma.patch` | GNOME Night Light via DCP gamma LUT |

## Local build (carrier — x86_64 → aarch64)

```bash
nix build .#cross.aarch64-linux.default
```

## Trigger a release build

```bash
gh workflow run build.yml -f tag=asahi-7.1.5-1
```
