#!/usr/bin/env python3
"""Compose Google Play feature graphic (1024x500) with a real UI print."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "docs/stores/store-assets/feature_graphic/feature_graphic_1024x500.png"
DEFAULT_PRINT = ROOT / "docs/stores/prints/01_home_seu_dia.png"
FONT_BOLD = Path(r"C:/Windows/Fonts/segoeuib.ttf")
FONT_REG = Path(r"C:/Windows/Fonts/segoeui.ttf")

TEAL = (0x1A, 0x6B, 0x52)
TEAL_DARK = (0x0F, 0x45, 0x35)
GOLD = (0xF5, 0xC5, 0x18)
WHITE = (255, 255, 255)
BEZEL = (28, 28, 30)
SCREEN_BG = (18, 18, 20)

CANVAS = (1024, 500)
HEADLINE = "Organize a facul\nno bolso."
SUBLINE = "ConectaFERSA · offline"


def _font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = FONT_BOLD if bold else FONT_REG
    if path.is_file():
        return ImageFont.truetype(str(path), size=size)
    return ImageFont.load_default()


def _vertical_gradient(size: tuple[int, int]) -> Image.Image:
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


def _phone_with_screen(screen: Image.Image, phone_h: int) -> Image.Image:
    aspect = screen.width / screen.height
    phone_w = int(phone_h * aspect)
    bezel = max(10, phone_h // 42)
    radius_outer = max(28, phone_h // 14)
    radius_inner = max(18, phone_h // 20)

    canvas = Image.new("RGBA", (phone_w + bezel * 2, phone_h + bezel * 2), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    outer = (0, 0, phone_w + bezel * 2 - 1, phone_h + bezel * 2 - 1)
    draw.rounded_rectangle(outer, radius=radius_outer, fill=BEZEL)

    inner = (
        bezel,
        bezel,
        bezel + phone_w - 1,
        bezel + phone_h - 1,
    )
    draw.rounded_rectangle(inner, radius=radius_inner, fill=SCREEN_BG)

    fitted = screen.resize((phone_w, phone_h), Image.Resampling.LANCZOS)
    canvas.paste(fitted, (bezel, bezel))
    return canvas


def compose(*, print_path: Path, out_path: Path, headline: str = HEADLINE) -> None:
    canvas = _vertical_gradient(CANVAS)
    draw = ImageDraw.Draw(canvas)

    # Soft watermark circle (brand accent, no fake crest).
    wm_r = 220
    wm = Image.new("RGBA", (wm_r * 2, wm_r * 2), (0, 0, 0, 0))
    ImageDraw.Draw(wm).ellipse((0, 0, wm_r * 2 - 1, wm_r * 2 - 1), fill=(255, 255, 255, 18))
    canvas.paste(wm, (40, 120), wm)

    title_font = _font(52, bold=True)
    sub_font = _font(22, bold=False)
    x_text = 56
    y = 118
    for line in headline.split("\n"):
        draw.text((x_text, y), line, font=title_font, fill=WHITE)
        y += 58
    draw.rectangle((x_text, y + 8, x_text + 120, y + 14), fill=GOLD)
    draw.text((x_text, y + 28), SUBLINE, font=sub_font, fill=(184, 212, 203))

    screen = Image.open(print_path).convert("RGB")
    # Trim emulator chrome slightly; keeps real in-app UI.
    trim_top = int(screen.height * 0.055)
    screen = screen.crop((0, trim_top, screen.width, screen.height))

    phone_h = 430
    phone = _phone_with_screen(screen, phone_h)
    phone = phone.rotate(-8, expand=True, resample=Image.Resampling.BICUBIC)

    px = CANVAS[0] - phone.width - 36
    py = (CANVAS[1] - phone.height) // 2 + 8
    canvas.paste(phone, (px, py), phone)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path, optimize=True)
    print(f"wrote {out_path} ({canvas.size[0]}x{canvas.size[1]})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--print", type=Path, default=DEFAULT_PRINT, dest="print_path")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()
    compose(print_path=args.print_path.resolve(), out_path=args.out.resolve())


if __name__ == "__main__":
    main()
