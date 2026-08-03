{
  description = "cyb3r-kernel — patched Asahi Linux kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    asahi-kernel = {
      url = "github:AsahiLinux/linux/e3e35907c17a05773d481e58a566bf9108166cc5";  # fairydust
      flake = false;
    };
  };

  outputs = { self, nixpkgs, asahi-kernel }: let
    kernelPatches = [
      { name = "agx-fdinfo";     patch = ./patches/0001-agx-fdinfo-telemetry.patch; }
      { name = "dcp-nightlight"; patch = ./patches/0100-dcp-nightlight-gamma.patch; }
    ];
    kernelConfig = with nixpkgs.lib.kernel; {
      ARM64_16K_PAGES = yes;
      ARM64_MEMORY_MODEL_CONTROL = yes;
      ARM64_ACTLR_STATE = yes;
      APPLE_WATCHDOG = yes;
      APPLE_M1_CPU_PMU = yes;
      HID_APPLE = module;
      APPLE_PMGR_MISC = yes;
      APPLE_PMGR_PWRSTATE = yes;
      DRM_ASAHI = module;
      DRM_APPLE = module;
      DRM_APPLE_AUDIO = yes;
      TYPEC_DP_ALTMODE = module;
      MUX_APPLE_DPXBAR = module;
      TYPEC_NVIDIA_ALTMODE = module;
      TYPEC_TBT_ALTMODE = module;
      RUST_FW_LOADER_ABSTRACTIONS = yes;
      RUST_DRM_GEM_SHMEM_HELPER = yes;
      RUST_DRM_GPUVM = yes;
      RUST_APPLE_MAILBOX = yes;
      RUST_APPLE_RTKIT = yes;
      RUST_DRM_SCHED = yes;
    };
    mkKernel = pkgs: pkgs.buildLinux {
      src = asahi-kernel;
      version = "7.1.5-cyb3r";
      modDirVersion = "7.1.5";
      inherit kernelPatches;
      structuredExtraConfig = kernelConfig;
      features.rust = true;
    };
  in {
    packages.aarch64-linux.default =
      mkKernel nixpkgs.legacyPackages.aarch64-linux;

    # Cross-compile from x86_64 → aarch64 (for carrier)
    packages.x86_64-linux.cross-aarch64 =
      mkKernel nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
  };
}
