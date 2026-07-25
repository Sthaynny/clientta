#!/usr/bin/env python3
"""Compose Google Play tablet promo screenshots (7" and 10") from real UI prints.

Layout: headline panel ~30% left + landscape tablet mockup ~70% right.
Used by the publicidade skill when UI fidelity matters more than GenerateImage.

Requires: pip install Pillow
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SIZES = {
    "tablet_7": (1920, 1080),
    "tablet_10": (2560, 1440),
}

DEFAULT_FONT_BOLD = Path(r"C:/Windows/Fonts/segoeuib.ttf")
DEFAULT_FONT_REG = Path(r"C:/Windows/Fonts/segoeui.ttf")


@dataclass(frozen=True)
class TabletCard:
    index: int
    slug: str
    headline: str
    print_name: str


def _hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.strip().lstrip("#")
    if len(value) != 6:
        raise ValueError(f"Expected #RRGGBB, got {value!r}")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def _load_config(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def _cards_from_config(data: dict) -> tuple[TabletCard, ...]:
    cards: list[TabletCard] = []
    for entry in data["cards"]:
        cards.append(
            TabletCard(
                index=int(entry["index"]),
                slug=str(entry["slug"]),
                headline=str(entry["headline"]),
                print_name=str(entry["print_name"]),
            )
        )
    return tuple(cards)


def _load_font(size: int, bold: bool, font_bold: Path, font_reg: Path) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = font_bold if bold else font_reg
    if path.is_file():
        return ImageFont.truetype(str(path), size=size)
    return ImageFont.load_default()


def _wrap_headline(
    draw: ImageDraw.ImageDraw,
    text: str,
    font: ImageFont.FreeTypeFont | ImageFont.ImageFont,
    max_width: int,
) -> list[str]:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        trial = f"{current} {word}".strip()
        if draw.textlength(trial, font=font) <= max_width:
            current = trial
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def _rounded_rect(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    radius: int,
    fill: tuple[int, int, int],
) -> None:
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def compose_card(
    card: TabletCard,
    canvas_size: tuple[int, int],
    *,
    prints_dir: Path,
    teal: tuple[int, int, int],
    teal_dark: tuple[int, int, int],
    gold: tuple[int, int, int],
    tag_lines: tuple[str, ...],
    font_bold: Path,
    font_reg: Path,
) -> Image.Image:
    white = (255, 255, 255)
    bezel = (28, 28, 30)
    screen_bg = (18, 18, 20)

    width, height = canvas_size
    canvas = Image.new("RGB", canvas_size, teal_dark)
    draw = ImageDraw.Draw(canvas)

    panel_w = int(width * 0.30)
    draw.rectangle((0, 0, panel_w, height), fill=teal)
    draw.rectangle((panel_w - 4, 0, panel_w, height), fill=gold)

    headline_font = _load_font(max(32, height // 22), bold=True, font_bold=font_bold, font_reg=font_reg)
    tag_font = _load_font(max(18, height // 48), bold=False, font_bold=font_bold, font_reg=font_reg)
    pad = int(width * 0.025)
    max_text_w = panel_w - pad * 2
    lines = _wrap_headline(draw, card.headline, headline_font, max_text_w)
    y = int(height * 0.22)
    line_h = int(getattr(headline_font, "size", 32) * 1.25)
    for line in lines:
        draw.text((pad, y), line, font=headline_font, fill=white)
        y += line_h

    if tag_lines:
        tag_block_h = tag_font.size * len(tag_lines) if hasattr(tag_font, "size") else 40 * len(tag_lines)
        tag_y = height - pad - tag_block_h
        for line in tag_lines:
            draw.text((pad, tag_y), line, font=tag_font, fill=gold)
            tag_y += int(getattr(tag_font, "size", 18))

    print_path = prints_dir / card.print_name
    if not print_path.is_file():
        raise FileNotFoundError(f"Print not found: {print_path}")
    screen = Image.open(print_path).convert("RGB")

    margin_x = int(width * 0.04)
    tablet_left = panel_w + margin_x
    tablet_top = int(height * 0.08)
    tablet_right = width - margin_x
    tablet_bottom = int(height * 0.92)
    bezel_px = 14 if height <= 1080 else 18
    inner_left = tablet_left + bezel_px
    inner_top = tablet_top + bezel_px
    inner_right = tablet_right - bezel_px
    inner_bottom = tablet_bottom - bezel_px
    inner_w = inner_right - inner_left
    inner_h = inner_bottom - inner_top

    _rounded_rect(draw, (tablet_left, tablet_top, tablet_right, tablet_bottom), 28, bezel)
    _rounded_rect(draw, (inner_left, inner_top, inner_right, inner_bottom), 18, screen_bg)

    sw, sh = screen.size
    scale = min(inner_w / sw, inner_h / sh)
    new_w = int(sw * scale)
    new_h = int(sh * scale)
    resized = screen.resize((new_w, new_h), Image.Resampling.LANCZOS)
    paste_x = inner_left + (inner_w - new_w) // 2
    paste_y = inner_top + (inner_h - new_h) // 2
    canvas.paste(resized, (paste_x, paste_y))
    return canvas


def run(
    *,
    prints_dir: Path,
    out_base: Path,
    cards: tuple[TabletCard, ...],
    teal: tuple[int, int, int],
    teal_dark: tuple[int, int, int],
    gold: tuple[int, int, int],
    tag_lines: tuple[str, ...],
    font_bold: Path,
    font_reg: Path,
) -> None:
    for folder, size in SIZES.items():
        out_dir = out_base / folder
        out_dir.mkdir(parents=True, exist_ok=True)
        for card in cards:
            image = compose_card(
                card,
                size,
                prints_dir=prints_dir,
                teal=teal,
                teal_dark=teal_dark,
                gold=gold,
                tag_lines=tag_lines,
                font_bold=font_bold,
                font_reg=font_reg,
            )
            filename = f"{card.index:02d}_{card.slug}.png"
            out_path = out_dir / filename
            image.save(out_path, optimize=True)
            print(f"wrote {out_path} ({image.size[0]}x{image.size[1]})")


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Compose Play tablet promo screenshots from UI prints.")
    parser.add_argument("--prints-dir", type=Path, required=True, help="Folder with source PNG prints")
    parser.add_argument(
        "--out-base",
        type=Path,
        required=True,
        help="Base folder; writes tablet_7/ and tablet_10/ underneath",
    )
    parser.add_argument(
        "--config",
        type=Path,
        required=True,
        help="JSON: colors, tag_lines, cards (index, slug, headline, print_name)",
    )
    parser.add_argument("--font-bold", type=Path, default=DEFAULT_FONT_BOLD)
    parser.add_argument("--font-reg", type=Path, default=DEFAULT_FONT_REG)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    config = _load_config(args.config)
    cards = _cards_from_config(config)
    teal = _hex_to_rgb(config.get("teal", "#0B4F4A"))
    teal_dark = _hex_to_rgb(config.get("teal_dark", "#06302D"))
    gold = _hex_to_rgb(config.get("gold", "#E8A317"))
    raw_tags = config.get("tag_lines", [])
    tag_lines = tuple(str(line) for line in raw_tags)

    run(
        prints_dir=args.prints_dir.resolve(),
        out_base=args.out_base.resolve(),
        cards=cards,
        teal=teal,
        teal_dark=teal_dark,
        gold=gold,
        tag_lines=tag_lines,
        font_bold=args.font_bold,
        font_reg=args.font_reg,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
