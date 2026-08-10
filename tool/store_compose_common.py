"""Shared composition helpers for Clientta store marketing assets."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

FONT_BOLD = Path(r"C:/Windows/Fonts/segoeuib.ttf")
FONT_REG = Path(r"C:/Windows/Fonts/segoeui.ttf")

TEAL = (0x1A, 0x6B, 0x52)
TEAL_DARK = (0x0F, 0x45, 0x35)
TEAL_LIGHT = (0x2A, 0x8A, 0x72)
GOLD = (0xF5, 0xC5, 0x18)
WHITE = (255, 255, 255)
BEZEL = (20, 20, 22)
BEZEL_EDGE = (42, 42, 46)
SCREEN_BG = (12, 12, 14)
MUTED = (184, 212, 203)

CANVAS_DEFAULT = (1080, 1920)
FEATURE_CANVAS = (1024, 500)


def font(size: int, *, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = FONT_BOLD if bold else FONT_REG
    if path.is_file():
        return ImageFont.truetype(str(path), size=size)
    return ImageFont.load_default()


def _rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), radius=radius, fill=255)
    return mask


def crop_emulator_screenshot(image: Image.Image) -> Image.Image:
    """Remove Android status bar, punch-hole area and gesture navigation bar."""
    rgb = image.convert("RGB")
    w, h = rgb.size
    pixels = rgb.load()

    top = 0
    for y in range(h):
        green_hits = 0
        for x in range(0, w, 24):
            r, g, b = pixels[x, y]
            if g > 70 and g > r + 18 and g > b + 10 and r < 90:
                green_hits += 1
        if green_hits >= max(6, (w // 24) // 3):
            top = y
            break

    if top <= 0:
        top = int(h * 0.058)

    bottom = h
    for y in range(h - 1, top, -1):
        dark_hits = 0
        for x in range(0, w, 24):
            r, g, b = pixels[x, y]
            if r < 40 and g < 40 and b < 40:
                dark_hits += 1
        if dark_hits >= max(6, (w // 24) // 2):
            bottom = y
            break

    if bottom - top < int(h * 0.7):
        top = int(h * 0.058)
        bottom = h - int(h * 0.028)

    return rgb.crop((0, top, w, bottom))


def diagonal_gradient(size: tuple[int, int], *, angle_deg: float = 125.0) -> Image.Image:
    w, h = size
    base = Image.new("RGB", size, TEAL_DARK)
    overlay = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    rad = math.radians(angle_deg)
    length = int(math.hypot(w, h))
    for i in range(length):
        t = i / max(length - 1, 1)
        r = int(TEAL_DARK[0] * (1 - t) + TEAL[0] * t)
        g = int(TEAL_DARK[1] * (1 - t) + TEAL[1] * t)
        b = int(TEAL_DARK[2] * (1 - t) + TEAL[2] * t)
        x0 = int(w / 2 + math.cos(rad) * (i - length / 2))
        y0 = int(h / 2 + math.sin(rad) * (i - length / 2))
        x1 = int(w / 2 + math.cos(rad + math.pi / 2) * w)
        y1 = int(h / 2 + math.sin(rad + math.pi / 2) * h)
        draw.line([(x0, y0), (x1, y1)], fill=(r, g, b, 255), width=2)

    return Image.alpha_composite(base.convert("RGBA"), overlay).convert("RGB")


def add_decor(
    canvas: Image.Image,
    *,
    variant: int = 0,
) -> None:
    """Subtle brand accents — different position per card for visual rhythm."""
    w, h = canvas.size
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)

    positions = [
        (int(w * 0.78), int(h * 0.12), 220),
        (int(w * 0.08), int(h * 0.18), 180),
        (int(w * 0.86), int(h * 0.28), 160),
        (int(w * 0.12), int(h * 0.10), 200),
        (int(w * 0.72), int(h * 0.22), 190),
    ]
    cx, cy, radius = positions[variant % len(positions)]
    draw.ellipse(
        (cx - radius, cy - radius, cx + radius - 1, cy + radius - 1),
        fill=(255, 255, 255, 22),
    )

    stripe_y = int(h * (0.30 if variant % 2 else 0.34))
    draw.rectangle((0, stripe_y, w, stripe_y + int(h * 0.42)), fill=(255, 255, 255, 10))

    canvas.paste(Image.alpha_composite(canvas.convert("RGBA"), layer).convert("RGB"))


def draw_headline_block(
    draw: ImageDraw.ImageDraw,
    *,
    headline: str,
    y_start: int,
    x: int = 64,
    title_size: int = 72,
    brand_size: int = 28,
    brand: str | None = "Clientta",
) -> int:
    title_font = font(title_size, bold=True)
    brand_font = font(brand_size, bold=False)

    y = y_start
    for line in headline.split("\n"):
        draw.text((x, y), line, font=title_font, fill=WHITE)
        y += int(title_size * 1.12)

    accent_w = min(140, max(96, len(headline.split("\n")[0]) * 10))
    draw.rectangle((x, y + 10, x + accent_w, y + 16), fill=GOLD)
    if brand:
        draw.text((x, y + 28), brand, font=brand_font, fill=MUTED)
        return y + 64
    return y + 20


def _drop_shadow(size: tuple[int, int], *, blur: int = 28, opacity: int = 90) -> Image.Image:
    shadow = Image.new("RGBA", size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (blur, blur, size[0] - blur - 1, size[1] - blur - 1),
        radius=max(36, size[1] // 18),
        fill=(0, 0, 0, opacity),
    )
    return shadow.filter(ImageFilter.GaussianBlur(blur))


def build_phone_mockup(
    screen: Image.Image,
    *,
    target_height: int,
    shadow: bool = True,
) -> Image.Image:
    """Build a modern phone frame with rounded screen mask and optional shadow."""
    screen = crop_emulator_screenshot(screen)
    aspect = screen.width / screen.height

    inner_h = target_height
    inner_w = max(1, int(inner_h * aspect))
    inner_radius = max(28, inner_h // 34)

    bezel_side = max(10, inner_h // 52)
    bezel_top = max(14, inner_h // 38)
    bezel_bottom = max(18, inner_h // 30)
    outer_w = inner_w + bezel_side * 2
    outer_h = inner_h + bezel_top + bezel_bottom
    outer_radius = max(42, inner_h // 22)

    fitted = screen.resize((inner_w, inner_h), Image.Resampling.LANCZOS)
    screen_rgba = Image.new("RGBA", (inner_w, inner_h), (0, 0, 0, 0))
    screen_rgba.paste(fitted, (0, 0))
    mask = _rounded_mask((inner_w, inner_h), inner_radius)
    screen_rgba.putalpha(mask)

    phone = Image.new("RGBA", (outer_w, outer_h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(phone)

    draw.rounded_rectangle((0, 0, outer_w - 1, outer_h - 1), radius=outer_radius, fill=BEZEL)
    draw.rounded_rectangle(
        (2, 2, outer_w - 3, outer_h - 3),
        radius=outer_radius - 2,
        fill=BEZEL_EDGE,
    )

    screen_x = bezel_side
    screen_y = bezel_top
    phone.paste(screen_rgba, (screen_x, screen_y), screen_rgba)

    notch_w = max(64, inner_w // 5)
    notch_h = max(10, inner_h // 70)
    notch_x = screen_x + (inner_w - notch_w) // 2
    notch_y = screen_y + max(6, inner_h // 90)
    draw.rounded_rectangle(
        (notch_x, notch_y, notch_x + notch_w, notch_y + notch_h),
        radius=notch_h // 2,
        fill=(8, 8, 10),
    )

    if not shadow:
        return phone

    pad = 56
    canvas = Image.new("RGBA", (outer_w + pad * 2, outer_h + pad * 2), (0, 0, 0, 0))
    sh = _drop_shadow((outer_w + pad, outer_h + pad))
    canvas.alpha_composite(sh, (pad // 2, pad // 2 + 10))
    canvas.alpha_composite(phone, (pad, pad))
    return canvas


def paste_phone(
    canvas: Image.Image,
    phone: Image.Image,
    *,
    area_top: int,
    area_bottom: int,
    tilt_deg: float = -4.0,
    x_bias: float = 0.5,
) -> None:
    if abs(tilt_deg) > 0.1:
        phone = phone.rotate(tilt_deg, expand=True, resample=Image.Resampling.BICUBIC)

    area_h = area_bottom - area_top
    max_h = area_h - 16
    if phone.height > max_h:
        scale = max_h / phone.height
        new_size = (max(1, int(phone.width * scale)), max(1, int(phone.height * scale)))
        phone = phone.resize(new_size, Image.Resampling.LANCZOS)

    px = int((canvas.width - phone.width) * x_bias)
    px = max(24, min(px, canvas.width - phone.width - 24))
    py = area_top + max(0, (area_h - phone.height) // 2)
    py = min(py, canvas.height - phone.height - 20)
    py = max(area_top, py)
    canvas.paste(phone, (px, py), phone)
