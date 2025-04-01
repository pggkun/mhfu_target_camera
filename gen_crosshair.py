from PIL import Image

#1 = 140
#2 = 144
#3 = 145
#4 = 133

def convert_image_to_index_array(image_path):
    image = Image.open(image_path).convert("RGBA")
    width, height = image.size
    pixels = image.load()

    color_to_index = {}
    index_array = []
    next_index = 0

    for y in range(height):
        for x in range(width):
            color = pixels[x, y]
            if color not in color_to_index:
                color_to_index[color] = next_index
                next_index += 1
            index_array.append(color_to_index[color])

    return index_array, color_to_index, width, height

if __name__ == "__main__":
    image_path = "crosshair.png"
    index_array, color_map, w, h = convert_image_to_index_array(image_path)

    new_array = []
    for arr in index_array:
        if arr == 1:
            arr = 140
        elif arr == 2:
            arr = 144
        elif arr == 3:
            arr = 145
        elif arr == 4:
            arr = 133
        else:
            arr = 0
        new_array.append(arr)

    test_array = []
    for i in range(1024):
        if i<256:
            test_array.append(84)
        elif i<512:
            test_array.append(87)
        elif i<768:
            test_array.append(104)
        else:
            test_array.append(106)
    

    with open("bin/crosshair.bin", "wb") as f:
        f.write(bytes(new_array))
