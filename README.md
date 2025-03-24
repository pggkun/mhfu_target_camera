# MHFU Target Camera

Adds target camera, similar to that of Monster Hunter 4 to Monster Hunter Freedom Unite.

## Compiling

In a Linux environment, you will need Make and CMake. Use `make deps` to install the dependencies and `make` to generate the binaries and the text file.

## Usage

Use `L` + `DpadUp` to enable target camera. When target camera is enabled, pressing `L` will turn the camera to the target. 

Pressing `L` + `DpadDown` will disable the mod.

## Notes: 
For now, it only works on the Japanese `ULJM-05500` and European version `ULES-01213`, but I plan to implement it for the American `ULUS-10391` version as well. It's working on PPSSPP and has also been tested on a PSP 2000 using TempAR (unfortunately, for some reason, CWCheat causes some crashes).

### MHP2ndG (ULJM-05500, also compatible with FUComplete)
- [x] Target Cam
- [x] Change target with `L + DpadLeft` or `L + DpadRight`
- [x] Check if the selected target is in the same area
- [x] HUD with Monster Icons
- [ ] Crosshair

### MHFU-EU (ULES-01213)
- [x] Target Cam
- [ ] Change target with `L + DpadLeft` or `L + DpadRight`
- [ ] Check if the selected target is in the same area
- [ ] HUD with Monster Icons
- [ ] Crosshair

### MHFU-US (ULUS-10391)
- [ ] Target Cam
- [ ] Change target with `L + DpadLeft` or `L + DpadRight`
- [ ] Check if the selected target is in the same area
- [ ] HUD with Monster Icons
- [ ] Crosshair

## Credits: 
- Thanks to [Kurogami2134](https://github.com/Kurogami2134), that created [MHP3rd Target Cam](https://github.com/Kurogami2134/mhp3rd_target_camera.git) which was the base code for this project.
- Thanks to [IncognitoMan](https://github.com/IncognitoMan), that provided the monster ID list.