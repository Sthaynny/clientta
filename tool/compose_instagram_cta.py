#!/usr/bin/env python3
"""Compose Instagram CTA banner (4:5) for personal profile."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ICON = ROOT / "docs/stores/store-assets/icon/icon_512.png"
OUT = ROOT / "docs/stores/store-assets/banners/instagram/ig_05_cta.png"
FONT_BOLD = Path(r"C:/Windows/Fonts/segoeuib.ttf")
FONT_REG = Path(r"C:/Windows/Fonts/segoeui.ttf")

TEAL = (0x1A, 0x6B, 0x52)
TEAL_DARK = (0x0F, 0x45, 0x35)
WHITE = (255, 255, 255)
CANVAS = (1080, 1350)


def _font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = FONT_BOLD if bold else FONT_REG
    if path.is_file():
        return ImageFont.truetype(str(path), size=size)
    return ImageFont.load_default()


def _gradient(size: tuple[int, int]) -> Image.Image:
    w, h = size
    base = Image.new("RGB", size, TEAL_DARK)
    draw = ImageDraw.Draw(base)
    for y in range(h):
        t = y / max(h - 1, 1)
        r = int(TEAL_DARK[0] * (1 - t) + TEAL[0] * t)
        g = int(TEAL_DARK[1] * (1 - t) + TEAL[1] * t)
        b = int(TEAL_DARK[2] * (1 - t) + TEAL[2] * t)
        draw.line([(0, y), (w, y)], fill=(r, g, b))
    return base


def main() -> None:
    canvas = _gradient(CANVAS)
    draw = ImageDraw.Draw(canvas)

    icon = Image.open(ICON).convert("RGBA")
    icon_size = 220
    icon = icon.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
    ix = (CANVAS[0] - icon_size) // 2
    iy = int(CANVAS[1] * 0.28)
    canvas.paste(icon, (ix, iy), icon)

    title = _font(64, bold=True)
    sub = _font(34, bold=False)

    draw.text((CANVAS[0] // 2, iy + icon_size + 48), "Clientta", font=title, fill=WHITE, anchor="mt")
    draw.text(
        (CANVAS[0] // 2, iy + icon_size + 130),
        "Em breve na Play Store",
        font=sub,
        fill=(184, 212, 203),
        anchor="mt",
    )
    draw.text(
        (CANVAS[0] // 2, iy + icon_size + 200),
        "Segue para acompanhar",
        font=sub,
        fill=WHITE,
        anchor="mt",
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(OUT, optimize=True)
    print(f"wrote {OUT} ({CANVAS[0]}x{CANVAS[1]})")


if __name__ == "__main__":
    main()
