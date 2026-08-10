#!/usr/bin/env python3
"""Compose Instagram CTA banner (4:5) for personal profile."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

from store_compose_common import (
    GOLD,
    MUTED,
    WHITE,
    add_decor,
    diagonal_gradient,
    font,
)

ROOT = Path(__file__).resolve().parents[1]
ICON = ROOT / "docs/stores/store-assets/icon/icon_512.png"
OUT = ROOT / "docs/stores/store-assets/banners/instagram/ig_05_cta.png"

CANVAS = (1080, 1350)


def main() -> None:
    canvas = diagonal_gradient(CANVAS, angle_deg=130)
    add_decor(canvas, variant=4)
    draw = ImageDraw.Draw(canvas)

    icon = Image.open(ICON).convert("RGBA")
    icon_size = 220
    icon = icon.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
    ix = (CANVAS[0] - icon_size) // 2
    iy = int(CANVAS[1] * 0.28)
    canvas.paste(icon, (ix, iy), icon)

    title = font(64, bold=True)
    sub = font(34, bold=False)

    text_y = iy + icon_size + 48
    draw.text((CANVAS[0] // 2, text_y), "Clientta", font=title, fill=WHITE, anchor="mt")
    draw.rectangle(
        (CANVAS[0] // 2 - 70, text_y + 72, CANVAS[0] // 2 + 70, text_y + 78),
        fill=GOLD,
    )
    draw.text(
        (CANVAS[0] // 2, text_y + 96),
        "Em breve na Play Store",
        font=sub,
        fill=MUTED,
        anchor="mt",
    )
    draw.text(
        (CANVAS[0] // 2, text_y + 152),
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
