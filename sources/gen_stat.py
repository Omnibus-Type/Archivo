from fontTools.otlLib.builder import buildStatTable, _addName
from fontTools.ttLib import TTFont
import sys


UPRIGHT_AXES = [
    dict(
        tag="wdth",
        name="Width",
        ordering=0,
        values=[
            dict(nominalValue=62, rangeMinValue=62, rangeMaxValue=75, name="ExtraCondensed"),
            dict(nominalValue=75, rangeMinValue=75, rangeMaxValue=87.5, name="Condensed"),
            dict(nominalValue=87.5, rangeMinValue=87.5, rangeMaxValue=100, name="SemiCondensed"),
            dict(nominalValue=100, rangeMinValue=100, rangeMaxValue=110, name="Normal", flags=0x2),
            dict(nominalValue=112.5, rangeMinValue=110, rangeMaxValue=115, name="SemiExpanded"),
            dict(nominalValue=125, rangeMinValue=115, rangeMaxValue=125, name="Expanded"),
        ],
    ),
    dict(
        tag="wght",
        name="Weight",
        ordering=1,
        values=[
            dict(nominalValue=100, rangeMinValue=100, rangeMaxValue=150, name="Thin"),
            dict(nominalValue=200, rangeMinValue=150, rangeMaxValue=250, name="ExtraLight"),
            dict(nominalValue=300, rangeMinValue=250, rangeMaxValue=350, name="Light"),
            dict(nominalValue=400, rangeMinValue=350, rangeMaxValue=450, name="Regular", flags=0x2, LinkedValue=700), # Regular
            dict(nominalValue=500, rangeMinValue=450, rangeMaxValue=550, name="Medium"),
            dict(nominalValue=600, rangeMinValue=550, rangeMaxValue=650, name="SemiBold"),
            dict(nominalValue=700, rangeMinValue=650, rangeMaxValue=750, name="Bold"),
            dict(nominalValue=800, rangeMinValue=750, rangeMaxValue=850, name="ExtraBold"),
            dict(nominalValue=900, rangeMinValue=850, rangeMaxValue=900, name="Black"),
        ],
    ),
    dict(
        tag="ital",
        name="Italic",
        ordering=2,
        values=[
            dict(value=0, name="Roman", flags=0x2, LinkedValue=1), # Regular
        ],
    ),
]

ITALIC_AXES = [
    dict(
        tag="wdth",
        name="Width",
        ordering=0,
        values=[
            dict(nominalValue=62, rangeMinValue=62, rangeMaxValue=75, name="ExtraCondensed"),
            dict(nominalValue=75, rangeMinValue=75, rangeMaxValue=87.5, name="Condensed"),
            dict(nominalValue=87.5, rangeMinValue=87.5, rangeMaxValue=100, name="SemiCondensed"),
            dict(nominalValue=100, rangeMinValue=100, rangeMaxValue=110, name="Normal", flags=0x2),
            dict(nominalValue=112.5, rangeMinValue=110, rangeMaxValue=115, name="SemiExpanded"),
            dict(nominalValue=125, rangeMinValue=115, rangeMaxValue=125, name="Expanded"),
        ],
    ),
    dict(
        tag="wght",
        name="Weight",
        ordering=1,
        values=[
            dict(nominalValue=100, rangeMinValue=100, rangeMaxValue=150, name="Thin"),
            dict(nominalValue=200, rangeMinValue=150, rangeMaxValue=250, name="ExtraLight"),
            dict(nominalValue=300, rangeMinValue=250, rangeMaxValue=350, name="Light"),
            dict(nominalValue=400, rangeMinValue=350, rangeMaxValue=450, name="Regular", flags=0x2, LinkedValue=700), # Regular
            dict(nominalValue=500, rangeMinValue=450, rangeMaxValue=550, name="Medium"),
            dict(nominalValue=600, rangeMinValue=550, rangeMaxValue=650, name="SemiBold"),
            dict(nominalValue=700, rangeMinValue=650, rangeMaxValue=750, name="Bold"),
            dict(nominalValue=800, rangeMinValue=750, rangeMaxValue=850, name="ExtraBold"),
            dict(nominalValue=900, rangeMinValue=850, rangeMaxValue=900, name="Black"),
        ],
    ),
    dict(
        tag="ital",
        name="Italic",
        ordering=2,
        values=[
            dict(value=1, name="Italic"), # Italic
        ],
    ),
]

UPRIGHT_SRC = "../fonts/Archivo/variable/Archivo[wdth,wght].ttf"
ITALIC_SRC = "../fonts/Archivo/variable/Archivo-Italic[wdth,wght].ttf"

def update_fvar(ttfont):
    fvar = ttfont['fvar']
    nametable = ttfont['name']
    family_name = nametable.getName(16, 3, 1, 1033) or nametable.getName(1, 3, 1, 1033)
    family_name = family_name.toUnicode()
    font_style = "Italic" if "Italic" in ttfont.reader.file.name else "Roman"
    ps_family_name = "{family_name.replace(' ', '')}{font_style}"
    nametable.setName(ps_family_name, 25, 3, 1, 1033)
    for instance in fvar.instances:
        instance_style = nametable.getName(instance.subfamilyNameID, 3, 1, 1033).toUnicode()
        instance_style = instance_style.replace("Italic", "").strip()
        if instance_style == "":
            instance_style = "Regular"
        ps_name = "{ps_family_name}-{instance_style}"
        instance.postscriptNameID = _addName(nametable, ps_name, 256)


def main():
    # process upright files
    filepath = UPRIGHT_SRC
    tt = TTFont(filepath)
    buildStatTable(tt, UPRIGHT_AXES)
    update_fvar(tt)
    tt.save(filepath)
    print("[STAT TABLE] Added STAT table to {filepath}")

    # process italics files
    filepath = ITALIC_SRC
    tt = TTFont(filepath)
    buildStatTable(tt, ITALIC_AXES)
    update_fvar(tt)
    tt.save(filepath)
    print("[STAT TABLE] Added STAT table to {filepath}")


if __name__ == "__main__":
    main()