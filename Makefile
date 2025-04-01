ARMIPS_URL := https://github.com/Kingcom/armips.git
MODIO_URL := https://github.com/Kurogami2134/modio.git

BUILD_DIR := build
INSTALL_DIR := /usr/local/bin

CHEAT_FILE := CHEAT.TXT

.PHONY: deps, armips, modio

$(CHEAT_FILE):
	mkdir -p bin
	armips src/target_cam_mhfu_eu.asm
	armips src/target_cam_mhp2ndg.asm
	armips src/target_change_mhp2ndg.asm
	python3 gen_crosshair.py
	python3 gencwcheat.py

modio:
	if [ ! -d modio ]; then \
		git clone $(MODIO_URL); \
	fi
	mv modio/ModIO/cwcheatio.py ./

armips:
	if [ ! -d armips ]; then \
		git clone --recursive $(ARMIPS_URL); \
	fi

	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -DCMAKE_BUILD_TYPE=Release ../armips
	$(MAKE) -C $(BUILD_DIR)

	install -Dm755 $(BUILD_DIR)/armips $(INSTALL_DIR)/armips

patch:
	rm -rf *.iso
	rm -rf patched_*
	cp tools/*.iso ./
	python3 patcher.py
	gcc tools/UMD-replace.c -o umd_replace
	ls -la
	./umd_replace "$$(ls *.iso | head -n1)" /PSP_GAME/SYSDIR/EBOOT.BIN "$$(ls patched_* | head -n1)"
	
deps: armips modio

clean:
	rm -rf *.txt *.TXT
	rm -rf bin
	rm -rf umd_replace*

full_clean: clean
	rm -rf armips
	rm -rf modio
	rm -rf build
	rm -rf cwcheatio*
