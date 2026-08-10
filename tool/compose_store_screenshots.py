#!/usr/bin/env python3
"""Compose Google Play promotional phone screenshots (1080x1920) from real UI prints."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PRINTS = ROOT / "docs/stores/prints"
DEFAULT_OUT = ROOT / "docs/stores/store-assets/screenshots/phone"
FONT_BOLD = Path(r"C:/Windows/Fonts/segoeuib.ttf")
FONT_REG = Path(r"C:/Windows/Fonts/segoeui.ttf")

TEAL = (0x1A, 0x6B, 0x52)
TEAL_DARK = (0x0F, 0x45, 0x35)
WHITE = (255, 255, 255)
BEZEL = (28, 28, 30)
SCREEN_BG = (18, 18, 20)

CANVAS = (1080, 1920)
HEADLINE_RATIO = 0.32

SCREENSHOTS = [
    ("phone_01_home.png", "01_home_seu_dia.png", "Veja quem\natender hoje"),
    ("phone_02_agenda.png", "02_minha_agenda.png", "Agenda e clientes\norganizados"),
    ("phone_03_clientes.png", "03_meus_clientes.png", "Histórico de cada\nnegociação"),
    ("phone_04_atendimento.png", "04_atendimento_historico.png", "Registre sem\nperder contexto"),
    ("phone_05_offline.png", "01_home_seu_dia.png", "Funciona mesmo\nsem internet"),
]


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
    bezel = max(12, phone_h // 40)
    radius_outer = max(32, phone_h // 13)
    radius_inner = max(22, phone_h // 18)

    canvas = Image.new("RGBA", (phone_w + bezel * 2, phone_h + bezel * 2), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    outer = (0, 0, phone_w + bezel * 2 - 1, phone_h + bezel * 2 - 1)
    draw.rounded_rectangle(outer, radius=radius_outer, fill=BEZEL)

    inner = (bezel, bezel, bezel + phone_w - 1, bezel + phone_h - 1)
    draw.rounded_rectangle(inner, radius=radius_inner, fill=SCREEN_BG)

    fitted = screen.resize((phone_w, phone_h), Image.Resampling.LANCZOS)
    canvas.paste(fitted, (bezel, bezel))
    return canvas


def compose_one(*, print_path: Path, out_path: Path, headline: str) -> None:
    canvas = _vertical_gradient(CANVAS)
    draw = ImageDraw.Draw(canvas)

    headline_h = int(CANVAS[1] * HEADLINE_RATIO)
    title_font = _font(72, bold=True)
    sub_font = _font(28, bold=False)

    y = int(headline_h * 0.22)
    for line in headline.split("\n"):
        draw.text((64, y), line, font=title_font, fill=WHITE)
        y += 82

    draw.text((64, y + 12), "Clientta", font=sub_font, fill=(184, 212, 203))

    screen = Image.open(print_path).convert("RGB")
    trim_top = int(screen.height * 0.055)
    screen = screen.crop((0, trim_top, screen.width, screen.height))

    phone_h = int(CANVAS[1] * 0.58)
    phone = _phone_with_screen(screen, phone_h)
    px = (CANVAS[0] - phone.width) // 2
    py = headline_h + int((CANVAS[1] - headline_h - phone.height) * 0.42)
    canvas.paste(phone, (px, py), phone)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path, optimize=True)
    print(f"wrote {out_path} ({canvas.size[0]}x{canvas.size[1]})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prints", type=Path, default=PRINTS)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()

    for out_name, print_name, headline in SCREENSHOTS:
        compose_one(
            print_path=(args.prints / print_name).resolve(),
            out_path=(args.out / out_name).resolve(),
            headline=headline,
        )


if __name__ == "__main__":
    main()
