test-vm:
	nix build "./system#nixosConfigurations.test-vm.config.system.build.vm"
	QEMU_NET_OPTS=hostfwd=tcp::2221-:22 ./result/bin/run-test-vm-vm
