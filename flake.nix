{
  description = "cyb3r-kernel — patched Asahi Linux kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    asahi-kernel = {
      url = "github:AsahiLinux/linux?ref=asahi-7.1.5-1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, asahi-kernel }: {
    packages.aarch64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
      in
      pkgs.buildLinux {
        src = asahi-kernel;
        version = "7.1.5-cyb3r";
        modDirVersion = "7.1.5";
        kernelPatches = [
          { name = "nightlight"; patch = ./patches/asahi-nightlight.patch; }
          { name = "agx-fdinfo";  patch = ./patches/0001-agx-show-fdinfo-memory-stats.patch; }
        ];
        structuredExtraConfig = with pkgs.lib.kernel; {
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
          DRM_APPLE_DCP = module;
          TYPEC_DP_ALTMODE = module;
          MUX_APPLE_DPXBAR = module;
          RUST_FW_LOADER_ABSTRACTIONS = yes;
          RUST_DRM_GEM_SHMEM_HELPER = yes;
          RUST_DRM_GPUVM = yes;
          RUST_APPLE_MAILBOX = yes;
          RUST_APPLE_RTKIT = yes;
          RUST_DRM_SCHED = yes;
          DRM_GEM_SHMEM_HELPER = yes;
          DRM_GPUVM = yes;
        };
        features.rust = true;
      };
  };
}
