#!/usr/bin/env python3
"""Compose Instagram personal cover (4:5) with phone mockup."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

from store_compose_common import (
    add_decor,
    build_phone_mockup,
    diagonal_gradient,
    draw_headline_block,
    paste_phone,
)

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PRINT = ROOT / "docs/stores/prints/01_home_seu_dia.png"
OUT = ROOT / "docs/stores/store-assets/banners/instagram/ig_01_capa.png"

CANVAS = (1080, 1350)


def main() -> None:
    canvas = diagonal_gradient(CANVAS, angle_deg=125)
    add_decor(canvas, variant=0)
    draw = ImageDraw.Draw(canvas)

    headline_h = int(CANVAS[1] * 0.30)
    draw_headline_block(
        draw,
        headline="Passei meses\nconstruindo isso",
        y_start=int(headline_h * 0.12),
        title_size=58,
        brand_size=24,
        brand="no intervalo do trabalho",
    )

    screen = Image.open(DEFAULT_PRINT).convert("RGB")
    phone = build_phone_mockup(screen, target_height=int(CANVAS[1] * 0.42), shadow=True)
    paste_phone(
        canvas,
        phone,
        area_top=headline_h,
        area_bottom=CANVAS[1] - 20,
        tilt_deg=-5.0,
        x_bias=0.50,
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(OUT, optimize=True)
    print(f"wrote {OUT} ({CANVAS[0]}x{CANVAS[1]})")


if __name__ == "__main__":
    main()
