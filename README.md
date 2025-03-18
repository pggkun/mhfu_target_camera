# MHFU Target Camera

Adds target camera, similar to that of Monster Hunter 4 to Monster Hunter Freedom Unite.

## Compiling

In a Linux environment, you will need Make and CMake. Use `make deps` to install the dependencies and `make` to generate the binaries and the text file.

## Usage

Use `L` + `DpadUp` to enable target camera. When target camera is enabled, pressing `L` will turn the camera to the target. 

Pressing `L` + `DpadDown` will disable the mod.

## Notes: 
For now, it only works on the Japanese `ULJM-05500` and European version `ULES-01213`, but I plan to implement it for the American `ULUS-10391` version as well. It's working on PPSSPP and has also been tested on a PSP 2000 using TempAR (unfortunately, for some reason, CWCheat causes some crashes).

There's also no way to switch targets for now, it only selects the first available target in the map or area.

## Credits: 
This project was created by adapting the [MHP3rd Target Cam](https://github.com/Kurogami2134/mhp3rd_target_camera.git) by Kurogami2134, a much more advanced project that even has a UI.
