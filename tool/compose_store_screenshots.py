#!/usr/bin/env python3
"""Compose Google Play promotional phone screenshots (1080x1920) from real UI prints."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw

from store_compose_common import (
    CANVAS_DEFAULT,
    add_decor,
    build_phone_mockup,
    diagonal_gradient,
    draw_headline_block,
    paste_phone,
)

ROOT = Path(__file__).resolve().parents[1]
PRINTS = ROOT / "docs/stores/prints"
DEFAULT_OUT = ROOT / "docs/stores/store-assets/screenshots/phone"

CANVAS = CANVAS_DEFAULT
HEADLINE_RATIO = 0.34

SCREENSHOTS = [
    ("phone_01_home.png", "01_home_seu_dia.png", "Veja quem\natender hoje", -3.5, 0.50),
    ("phone_02_agenda.png", "02_minha_agenda.png", "Agenda e clientes\norganizados", 3.0, 0.48),
    ("phone_03_clientes.png", "03_meus_clientes.png", "Histórico de cada\nnegociação", -2.5, 0.52),
    ("phone_04_atendimento.png", "04_atendimento_historico.png", "Registre sem\nperder contexto", 2.5, 0.50),
    ("phone_05_offline.png", "01_home_seu_dia.png", "Funciona mesmo\nsem internet", -4.0, 0.50),
]


def compose_one(
    *,
    print_path: Path,
    out_path: Path,
    headline: str,
    variant: int,
    tilt_deg: float,
    x_bias: float,
) -> None:
    canvas = diagonal_gradient(CANVAS, angle_deg=118 + variant * 8)
    add_decor(canvas, variant=variant)
    draw = ImageDraw.Draw(canvas)

    headline_h = int(CANVAS[1] * HEADLINE_RATIO)
    draw_headline_block(draw, headline=headline, y_start=int(headline_h * 0.18))

    screen = Image.open(print_path).convert("RGB")
    phone_h = int(CANVAS[1] * 0.50)
    phone = build_phone_mockup(screen, target_height=phone_h, shadow=True)

    paste_phone(
        canvas,
        phone,
        area_top=headline_h,
        area_bottom=CANVAS[1] - 24,
        tilt_deg=tilt_deg,
        x_bias=x_bias,
    )

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path, optimize=True)
    print(f"wrote {out_path} ({CANVAS[0]}x{CANVAS[1]})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prints", type=Path, default=PRINTS)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()

    for index, (out_name, print_name, headline, tilt, x_bias) in enumerate(SCREENSHOTS):
        compose_one(
            print_path=(args.prints / print_name).resolve(),
            out_path=(args.out / out_name).resolve(),
            headline=headline,
            variant=index,
            tilt_deg=tilt,
            x_bias=x_bias,
        )


if __name__ == "__main__":
    main()
