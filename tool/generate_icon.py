"""Generates the temporary app icon / splash images (design.md section 6).

White map pin holding a green land polygon, on brand green #0F8A5F.
Replace with designer assets before release (plan.md P12-06).

Usage (from repo root):  python tool/generate_icon.py
Then:  dart run flutter_launcher_icons && dart run flutter_native_splash:create
"""
import math
import os

from PIL import Image, ImageDraw

BRAND = (15, 138, 95, 255)
WHITE = (255, 255, 255, 255)
SS = 4  # supersampling factor
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')


def draw_pin(draw, cx, cy, r):
    """Pin whose round head has radius r, centred so the whole pin is at cy."""
    head_cy = cy - r * 0.32
    tip = (cx, cy + r * 1.38)
    # Tangent points from the tip to the head circle.
    a = math.asin(r / (tip[1] - head_cy))
    draw.ellipse([cx - r, head_cy - r, cx + r, head_cy + r], fill=WHITE)
    left = (cx - r * math.cos(a), head_cy + r * math.sin(a))
    right = (cx + r * math.cos(a), head_cy + r * math.sin(a))
    draw.polygon([left, right, tip], fill=WHITE)

    # Land parcel polygon inside the head.
    shape = [(-0.55, -0.30), (0.05, -0.62), (0.60, -0.22), (0.42, 0.45), (-0.38, 0.52)]
    poly = [(cx + x * r * 0.95, head_cy + y * r * 0.95) for x, y in shape]
    draw.polygon(poly, fill=BRAND)
    dot = r * 0.11
    for x, y in poly:
        draw.ellipse([x - dot, y - dot, x + dot, y + dot], fill=WHITE,
                     outline=BRAND, width=max(1, int(dot * 0.45)))


def render(size, background, pin_scale):
    big = size * SS
    img = Image.new('RGBA', (big, big), background)
    draw = ImageDraw.Draw(img)
    draw_pin(draw, big / 2, big / 2, big * pin_scale / 2)
    return img.resize((size, size), Image.LANCZOS)


def main():
    os.makedirs(OUT, exist_ok=True)
    transparent = (0, 0, 0, 0)
    render(1024, BRAND, 0.42).save(os.path.join(OUT, 'app_icon.png'))
    # Adaptive foreground: keep inside the 66% safe zone.
    render(1024, transparent, 0.30).save(os.path.join(OUT, 'app_icon_foreground.png'))
    render(512, transparent, 0.62).save(os.path.join(OUT, 'splash_logo.png'))
    # Android 12 splash icon: content must fit the inner 2/3 circle.
    render(1152, transparent, 0.36).save(os.path.join(OUT, 'splash_logo_android12.png'))
    print('icons written to', os.path.abspath(OUT))


if __name__ == '__main__':
    main()
