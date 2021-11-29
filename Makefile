test-vm:
	nix build "./#nixosConfigurations.test-vm.config.system.build.vm"
	QEMU_NET_OPTS="hostfwd=tcp::2221-:22" ./result/bin/run-test-vm-vm

nixos:
	nix build "./#nixosConfigurations.nixos.config.system.build.vm"
	QEMU_NET_OPTS="hostfwd=tcp::2221-:22" ./result/bin/run-nixos-vm

build:
	nixos-rebuild build --flake ".#"

build-local:
	nixos-rebuild build --flake ".#" \
		--override-input "xmonad-kid" "path:../xmonad"

switch:
	sudo nixos-rebuild switch --flake ".#"

switch-local:
	sudo nixos-rebuild switch --flake ".#" \
		--override-input "xmonad-kid" "path:../xmonad"
