#!/usr/bin/env python3
"""Compose Google Play feature graphic (1024x500) with a real UI print."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw

from store_compose_common import (
    FEATURE_CANVAS,
    GOLD,
    MUTED,
    WHITE,
    add_decor,
    build_phone_mockup,
    diagonal_gradient,
    draw_headline_block,
    font,
    paste_phone,
)

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "docs/stores/store-assets/feature_graphic/feature_graphic_1024x500.png"
DEFAULT_PRINT = ROOT / "docs/stores/prints/01_home_seu_dia.png"

HEADLINE = "Agenda, clientes\ne contexto."
SUBLINE = "Clientta · offline no celular"


def compose(*, print_path: Path, out_path: Path, headline: str = HEADLINE) -> None:
    canvas = diagonal_gradient(FEATURE_CANVAS, angle_deg=140)
    add_decor(canvas, variant=2)
    draw = ImageDraw.Draw(canvas)

    draw_headline_block(draw, headline=headline, y_start=96, x=56, title_size=52, brand_size=22, brand=None)
    sub_font = font(22, bold=False)
    draw.text((56, 228), SUBLINE, font=sub_font, fill=MUTED)

    screen = Image.open(print_path).convert("RGB")
    phone = build_phone_mockup(screen, target_height=400, shadow=True)
    paste_phone(
        canvas,
        phone,
        area_top=24,
        area_bottom=FEATURE_CANVAS[1] - 24,
        tilt_deg=-7.0,
        x_bias=0.72,
    )

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path, optimize=True)
    print(f"wrote {out_path} ({FEATURE_CANVAS[0]}x{FEATURE_CANVAS[1]})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--print", type=Path, default=DEFAULT_PRINT, dest="print_path")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()
    compose(print_path=args.print_path.resolve(), out_path=args.out.resolve())


if __name__ == "__main__":
    main()
