#!/usr/bin/env python3
"""Regenerate launcher icons from docs/stores/store-assets/icon/icon_512.png."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "docs/stores/store-assets/icon/icon_512.png"
APP_ICON = ROOT / "assets/images/app-icon.png"
HUB_GREEN = (0x1B, 0x6B, 0x5C, 255)  # HubColors.seed — DESIGN.md

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


def load_master() -> Image.Image:
    return Image.open(MASTER).convert("RGBA")


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
    master = load_master()
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

    # In-app brand mark (transparent outside squircle).
    resize_transparent(master, 512).save(APP_ICON, optimize=True)

    print(f"Synced from {MASTER}")


if __name__ == "__main__":
    main()
