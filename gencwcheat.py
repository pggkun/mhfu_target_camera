from cwcheatio import CwCheatIO

def divide_file(filepath, text, amount, offset_0, offset_1):
    ALIGNMENT = 0x20
    with open(filepath, 'rb') as f:
        content = f.read()

    total_size = len(content)
    part_size = (total_size // amount) & ~(ALIGNMENT - 1)

    for i in range(amount):
        start = i * part_size
        end = start + part_size if i < amount - 1 else total_size

        chunk = content[start:end]
        if i < amount - 1 and len(chunk) % ALIGNMENT != 0:
            pad = ALIGNMENT - (len(chunk) % ALIGNMENT)
            chunk += b'\x00' * pad

        file.write(f"{text} [{i+offset_0}/{amount+offset_1}]")
        file.write(chunk)  

file = CwCheatIO("ULJM-05500.TXT")

amount = 20
file.seek(0x0891E2C0)
file.write(f"Target Cam [1/{amount+4}]")
with open("bin/VERTEX.bin", "rb") as bin:
    file.write(bin.read())

file.seek(0x0891C920)
file.write(f"Target Cam [2/{amount+4}]")
with open("bin/TARGET_CAM_JP.bin", "rb") as bin:
    file.write(bin.read())

file.write(f"Target Cam [3/{amount+4}]")
file.write(
    "_L 0x200871F8 0x0A247248\n"
)
file.seek(0x0891CAA0)
file.write(f"Target Cam [4/{amount+4}]")
file.write(
    "_L 0x20069408 0x0A2472A8\n"
)
divide_file("bin/TARGET_CHANGE_JP.bin", "Target Cam", amount, 5, 4)

file.seek(0x0891D510)
divide_file("bin/crosshair.bin", "Crosshair", 8, 1, 0)
# file.write(f"Target Cam [{amount+5}/{amount+5}]")
# with open("bin/crosshair.bin", "rb") as bin:
#     file.write(bin.read())

file.close()
