build_dir=build
raw_image=boot_sector.asm
image=NimbOS

all:
	mkdir -p $(build_dir)
	fasm $(raw_image) $(build_dir)/$(image)

run: all
	qemu-system-x86_64 $(build_dir)/$(image)

clean:
	rm -f $(build_dir)/*
	rmdir $(build_dir)
