# MHFU Target Camera

Adds target camera, similar to that of Monster Hunter 4 to Monster Hunter Freedom Unite.




https://github.com/user-attachments/assets/02b1270f-9c8a-45f4-9c3c-87644a94b8ec




## Compiling

In a Linux environment, you will need Make and CMake. Use `make deps` to install the dependencies and `make` to generate the binaries and the text file.

## Usage

Use `L + DpadUp` to enable target camera. When target camera is enabled, pressing `L` will turn the camera to the target. 

You can change the target with `L + DpadLeft` or `L + DpadRight`

Pressing `L + DpadDown` will disable the target camera.

## Patching

If you don't want to use this feature as a cheat, you can patch your ISO. To do that, you'll need:

- A MHP2ndG file in .iso format in the tools folder (it also works with MHFUComplete ISOs)
- A decrypted EBOOT.BIN in the root of the project (you can get it using PPSSPP or UMD_Gen)
    - if you use a MHFUComplete iso, the eboot file should match!
- Download [UMD-replace](https://www.romhacking.net/utilities/891/) and extract it into the tools folder

Once you have all these files and the other dependencies, run `make` to compile the binaries and `make patch` to generate your patched iso file.

## Notes

For now, it only works on the Japanese `ULJM-05500` and American `ULUS-10391` versions. It's working on PPSSPP and has also been tested on PSVita PCH-1000 and PSP 2000 using TempAR (unfortunately, for some reason, CWCheat causes some crashes).

- [x] Target Cam
- [x] Change target with `L + DpadLeft` or `L + DpadRight`
- [x] Check if the selected target is in the same area
- [x] HUD with Monster Icons
- [x] Crosshair

## Credits

- Thanks to [Kurogami2134](https://github.com/Kurogami2134), that created [MHP3rd Target Cam](https://github.com/Kurogami2134/mhp3rd_target_camera.git) which was the base code for this project.
- Thanks to [IncognitoMan](https://github.com/IncognitoMan), that provided the monster ID list.
