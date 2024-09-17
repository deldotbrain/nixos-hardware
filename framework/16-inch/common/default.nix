{ lib, pkgs, ... }: {
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../kmod.nix
    ../../framework-tool.nix
    ../../framework-sensor-config.nix
  ];

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6.8") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Enable keyboard customization
  hardware.keyboard.qmk.enable = lib.mkDefault true;

  # Allow `services.libinput.touchpad.disableWhileTyping` to work correctly.
  # Set unconditionally because libinput can also be configured dynamically via
  # gsettings.
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=Framework Laptop 16 Keyboard Module - ANSI Keyboard
    AttrKeyboardIntegration=internal
  '';
}
