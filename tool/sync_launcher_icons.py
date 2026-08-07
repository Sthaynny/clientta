#!/usr/bin/env python3
"""Regenerate launcher icons from docs/stores/store-assets/icon/icon_512.png."""

from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "docs/stores/store-assets/icon/icon_512.png"
APP_ICON = ROOT / "assets/images/app-icon.png"
APP_ICON_MARK = ROOT / "assets/images/app-icon-mark.png"
HUB_GREEN = (0x1B, 0x6B, 0x5C, 255)  # HubColors.seed — DESIGN.md
SQUIRCLE_RADIUS_RATIO = 0.2237

ANDROID_DENSITIES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}
ADAPTIVE_DENSITIES = {
    "mipmap-mdpi": 108,
    "mipmap-hdpi": 162,
    "mipmap-xhdpi": 216,
    "mipmap-xxhdpi": 324,
    "mipmap-xxxhdpi": 432,
}

IOS_ICONS: list[tuple[str, int]] = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("ItunesArtwork@2x.png", 1024),
]


def strip_outer_white(img: Image.Image) -> Image.Image:
    """Remove white padding and fringe connected to the image edges."""
    rgba = img.convert("RGBA")
    w, h = rgba.size
    data = rgba.load()
    visited: set[tuple[int, int]] = set()
    queue: deque[tuple[int, int]] = deque()

    def is_removable_white(r: int, g: int, b: int, a: int) -> bool:
        return a > 0 and r >= 250 and g >= 250 and b >= 250

    for x in range(w):
        for y in (0, h - 1):
            queue.append((x, y))
    for y in range(h):
        for x in (0, w - 1):
            queue.append((x, y))

    while queue:
        x, y = queue.popleft()
        if (x, y) in visited:
            continue
        visited.add((x, y))
        r, g, b, a = data[x, y]
        if a == 0:
            pass
        elif is_removable_white(r, g, b, a):
            data[x, y] = (r, g, b, 0)
        else:
            continue
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                nr, ng, nb, na = data[nx, ny]
                if na == 0 or is_removable_white(nr, ng, nb, na):
                    queue.append((nx, ny))

    return rgba


def apply_squircle_mask(img: Image.Image) -> Image.Image:
    rgba = img.convert("RGBA")
    w, h = rgba.size
    radius = int(min(w, h) * SQUIRCLE_RADIUS_RATIO)
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, w - 1, h - 1),
        radius=radius,
        fill=255,
    )
    out = rgba.copy()
    out.putalpha(mask)
    return out


def extract_foreground_mark(img: Image.Image) -> Image.Image:
    """White/blue glyph only — for dark app bars and drawer headers."""
    rgba = img.convert("RGBA")
    data = rgba.load()
    w, h = rgba.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = data[x, y]
            if a < 16:
                data[x, y] = (0, 0, 0, 0)
                continue
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            is_blue_accent = b > r + 20 and b > g and b > 60
            is_glyph = lum >= 150
            if not (is_glyph or is_blue_accent):
                data[x, y] = (0, 0, 0, 0)
    return rgba


def prepare_master() -> Image.Image:
    return apply_squircle_mask(strip_outer_white(Image.open(MASTER)))


def solid(size: int, color: tuple[int, int, int, int]) -> Image.Image:
    return Image.new("RGBA", (size, size), color)


def composite_on_green(src: Image.Image, size: int) -> Image.Image:
    base = solid(size, HUB_GREEN)
    layer = src.resize((size, size), Image.Resampling.LANCZOS)
    base.alpha_composite(layer)
    return base


def resize_transparent(src: Image.Image, size: int) -> Image.Image:
    return src.resize((size, size), Image.Resampling.LANCZOS)


def monochrome_from(src: Image.Image, size: int) -> Image.Image:
    rgba = resize_transparent(src, size)
    gray = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = rgba.load()
    gpx = gray.load()
    for y in range(size):
        for x in range(size):
            r, g, b, a = px[x, y]
            if a < 16:
                continue
            lum = int(0.299 * r + 0.587 * g + 0.114 * b)
            gpx[x, y] = (255, 255, 255, min(255, int(a * lum / 255)))
    return gray


def main() -> None:
    master = prepare_master()
    master.save(MASTER, optimize=True)

    res_android = ROOT / "android/app/src/main/res"

    for folder, px in ANDROID_DENSITIES.items():
        out = res_android / folder / "ic_launcher.png"
        composite_on_green(master, px).save(out, optimize=True)

    for folder, px in ADAPTIVE_DENSITIES.items():
        base = res_android / folder
        solid(px, HUB_GREEN).save(base / "ic_launcher_background.png", optimize=True)
        resize_transparent(master, px).save(base / "ic_launcher_foreground.png", optimize=True)
        monochrome_from(master, px).save(base / "ic_launcher_monochrome.png", optimize=True)

    ios_dir = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for name, px in IOS_ICONS:
        img = composite_on_green(master, px)
        img.save(ios_dir / name, optimize=True)

    resize_transparent(master, 512).save(APP_ICON, optimize=True)
    resize_transparent(extract_foreground_mark(master), 512).save(APP_ICON_MARK, optimize=True)

    print(f"Synced from {MASTER}")


if __name__ == "__main__":
    main()
