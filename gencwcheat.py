from cwcheatio import CwCheatIO

file = CwCheatIO("ULES-01213.TXT")
file.seek(0x9FF7E00)
file.write("Target Cam [1/3]")
with open("bin/TARGET_CAM_EU.bin", "rb") as bin:
    file.write(bin.read())

file.write("Target Cam [2/3]")
file.write(
    "_L 0xD0000001 0x10000110\n"
    "_L 0x200874F4 0x0A7FDF80\n"
)
file.write("Target Cam [3/3]")
file.write(
    "_L 0xD0000001 0x10000140\n"
    "_L 0x200874F4 0x8E6401F4\n"
)
file.close()