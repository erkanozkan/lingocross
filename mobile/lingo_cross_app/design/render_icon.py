"""LingoCross app icon → 1024x1024 PNG (square, no alpha). Two crossed speech bubbles.
Each bubble (rounded rect + short tail) is rotated about its OWN centre, then the two
are offset diagonally so they overlap into an "X" while both stay clearly visible.
Supersampled 4x for crisp edges, then downscaled."""
from PIL import Image, ImageDraw

K = 4
S = 1024 * K
BG = (0, 88, 190)        # #0058be
ORANGE = (254, 166, 25)  # #fea619
WHITE = (255, 255, 255)


def s(v):
    return int(round(v * K))


def bubble(color, cx, cy, w, h, radius, tail, angle):
    """One bubble on its own layer, rotated about its centre (cx, cy)."""
    layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.rounded_rectangle(
        [s(cx - w / 2), s(cy - h / 2), s(cx + w / 2), s(cy + h / 2)],
        radius=s(radius), fill=color,
    )
    d.polygon([(s(px), s(py)) for px, py in tail], fill=color)
    return layer.rotate(angle, resample=Image.BICUBIC, center=(s(cx), s(cy)))


base = Image.new("RGBA", (S, S), BG + (255,))

# Orange bubble — lower-right, tilted clockwise, tail down-right (drawn behind).
oc = (600, 566)
base = Image.alpha_composite(base, bubble(
    ORANGE + (255,), cx=oc[0], cy=oc[1], w=384, h=224, radius=58,
    tail=[(oc[0] + 8, oc[1] + 112 - 8), (oc[0] + 120, oc[1] + 188),
          (oc[0] + 84, oc[1] + 112 - 8)],
    angle=16,
))

# White bubble — upper-left, tilted counter-clockwise, tail down-left (drawn in front).
wc = (438, 452)
base = Image.alpha_composite(base, bubble(
    WHITE + (255,), cx=wc[0], cy=wc[1], w=384, h=224, radius=58,
    tail=[(wc[0] - 8, wc[1] + 112 - 8), (wc[0] - 120, wc[1] + 188),
          (wc[0] - 84, wc[1] + 112 - 8)],
    angle=-16,
))

out = base.convert("RGB").resize((1024, 1024), Image.LANCZOS)
out.save("assets/icon/app_icon.png")
print("wrote assets/icon/app_icon.png", out.size, out.mode)
