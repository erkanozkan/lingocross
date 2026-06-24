"""LingoCross splash logo → transparent PNG (just the crossed bubbles, no blue bg).
The blue background is applied by flutter_native_splash (color #0058be). Centred so
flutter_native_splash places it in the middle of the launch screen."""
from PIL import Image, ImageDraw

K = 4
S = 1024 * K
ORANGE = (254, 166, 25)
WHITE = (255, 255, 255)

# Shift the icon composition so the two bubbles are optically centred on the canvas.
DX, DY = -8, -12


def s(v):
    return int(round(v * K))


def bubble(color, cx, cy, w, h, radius, tail, angle):
    cx += DX
    cy += DY
    tail = [(px + DX, py + DY) for px, py in tail]
    layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.rounded_rectangle(
        [s(cx - w / 2), s(cy - h / 2), s(cx + w / 2), s(cy + h / 2)],
        radius=s(radius), fill=color,
    )
    d.polygon([(s(px), s(py)) for px, py in tail], fill=color)
    return layer.rotate(angle, resample=Image.BICUBIC, center=(s(cx), s(cy)))


base = Image.new("RGBA", (S, S), (0, 0, 0, 0))

oc = (600, 566)
base = Image.alpha_composite(base, bubble(
    ORANGE + (255,), cx=oc[0], cy=oc[1], w=384, h=224, radius=58,
    tail=[(oc[0] + 8, oc[1] + 104), (oc[0] + 120, oc[1] + 188), (oc[0] + 84, oc[1] + 104)],
    angle=16,
))

wc = (438, 452)
base = Image.alpha_composite(base, bubble(
    WHITE + (255,), cx=wc[0], cy=wc[1], w=384, h=224, radius=58,
    tail=[(wc[0] - 8, wc[1] + 104), (wc[0] - 120, wc[1] + 188), (wc[0] - 84, wc[1] + 104)],
    angle=-16,
))

out = base.resize((1024, 1024), Image.LANCZOS)
out.save("assets/icon/splash_logo.png")
print("wrote assets/icon/splash_logo.png", out.size, out.mode)
