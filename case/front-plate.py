from solid import scad_render_to_file, union

SEGMENTS = 48

def assembly():
    a = union()
    


    return a

if __name__ == "__main__":
    a = assembly()
    scad_render_to_file(a, file_header=f"$fn = {SEGMENTS};", include_orig_code=True)
