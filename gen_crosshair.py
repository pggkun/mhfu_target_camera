from PIL import Image

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

def print_index_grid(index_array, width, height):
    for y in range(height):
        row = index_array[y * width:(y + 1) * width]
        print(' '.join(f'{idx:2}' for idx in row))

if __name__ == "__main__":
    image_path = "crosshair.png"
    index_array, color_map, w, h = convert_image_to_index_array(image_path)

    clut_array = []
    for color in color_map.keys():
        clut_array.append(color[0])
        clut_array.append(color[1])
        clut_array.append(color[2])
        clut_array.append(color[3])

    index_array += clut_array

    print_index_grid(index_array, 32, 40)

    with open("bin/crosshair.bin", "wb") as f:
        f.write(bytes(index_array))
