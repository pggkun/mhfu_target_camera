from cwcheatio import CwCheatIO

def divide_file(filepath, amount):
    with open(filepath, 'rb') as f:
        content = f.read()

    total_size = len(content)
    part_size = total_size // amount

    for i in range(amount):
        start = i * part_size

        end = (i + 1) * part_size if i < amount - 1 else total_size
        file.write(f"Target Cam [{i+4}/{amount+3}]")
        file.write(content[start:end])
    


#=======================================================
# ULES-01213
#=======================================================
# file = CwCheatIO("ULES-01213.TXT")
# file.seek(0x9FF7E00)
# file.write("Target Cam [1/3]")
# with open("bin/TARGET_CAM_EU.bin", "rb") as bin:
#     file.write(bin.read())

# file.write("Target Cam [2/3]")
# file.write(
#     "_L 0xD0000001 0x10000110\n"
#     "_L 0x200874F4 0x0A7FDF80\n"
# )
# file.write("Target Cam [3/3]")
# file.write(
#     "_L 0xD0000001 0x10000140\n"
#     "_L 0x200874F4 0x8E6401F4\n"
# )
# file.close()
#=======================================================
# ULJM-05500
#=======================================================
file = CwCheatIO("ULJM-05500.TXT")
file.seek(0x0891C920)
amount = 20

file.write(f"Target Cam [1/{amount+3}]")
with open("bin/TARGET_CAM_JP.bin", "rb") as bin:
    file.write(bin.read())

file.write(f"Target Cam [2/{amount+3}]")
file.write(
    "_L 0x200871F8 0x0A247248\n"
)
file.seek(0x0891CAA0)
file.write(f"Target Cam [3/{amount+3}]")
file.write(
    "_L 0x20069408 0x0A2472A8\n"
)
divide_file("bin/TARGET_CHANGE_JP.bin", amount)

file.close()