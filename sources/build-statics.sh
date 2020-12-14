#!/bin/sh
set -e
fontName="Archivo"
fontName_it="Archivo-Italic"
axes="wdth,wght"

##########################################

echo ".
GENERATING TTF
."
TT_DIR=../fonts/Archivo/ttf
rm -rf $TT_DIR
mkdir -p $TT_DIR

fontmake -g $fontName.glyphs -i -o ttf --output-dir $TT_DIR
fontmake -g $fontName_it.glyphs -i -o ttf --output-dir $TT_DIR

echo ".
GENERATING OTF
."
OT_DIR=../fonts/Archivo/otf
rm -rf $OT_DIR
mkdir -p $OT_DIR

fontmake -g $fontName.glyphs -i -o otf --output-dir $OT_DIR
fontmake -g $fontName_it.glyphs -i -o otf --output-dir $OT_DIR

rm -rf instance_ufo/ master_ufo/

##########################################

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls $TT_DIR/*.ttf)
for font in $ttfs
do
	gftools fix-dsig --autofix $font
	python -m ttfautohint $font $font.fix
	mv $font.fix $font
	gftools fix-hinting $font
	mv $font.fix $font
done

echo ".
POST-PROCESSING OTF
."
otfs=$(ls $OT_DIR/*.otf)
for font in $otfs
do
 	gftools fix-dsig --autofix $font
 	gftools fix-weightclass $fonts
 	[ -f $font.fix ] && mv $font.fix $font
done


##########################################

echo ".
MOVING TTF
."

rm -rf ../fonts/Archivo/ttf ../fonts/ArchivoCondensed/ttf ../fonts/ArchivoExpanded/ttf ../fonts/ArchivoExtraCondensed/ttf ../fonts/ArchivoSemiCondensed/ttf ../fonts/ArchivoSemiExpanded/ttf

mkdir ../fonts/Archivo/ttf ../fonts/ArchivoCondensed/ttf ../fonts/ArchivoExpanded/ttf ../fonts/ArchivoExtraCondensed/ttf ../fonts/ArchivoSemiCondensed/ttf ../fonts/ArchivoSemiExpanded/ttf

mv $TT_DIR/Archivo*.ttf ../fonts/Archivo/ttf
mv $TT_DIR/ArchivoCondensed*.ttf ../fonts/ArchivoCondensed/ttf
mv $TT_DIR/ArchivoExpanded*.ttf ../fonts/ArchivoExpanded/ttf
mv $TT_DIR/ArchivoExtraCondensed*.ttf ../fonts/ArchivoExtraCondensed/ttf
mv $TT_DIR/ArchivoSemiCondensed*.ttf ../fonts/ArchivoSemiCondensed/ttf
mv $TT_DIR/ArchivoSemiExpanded*.ttf ../fonts/ArchivoSemiExpanded/ttf

echo ".
MOVING OTF
."

rm -rf ../fonts/Archivo/otf ../fonts/ArchivoCondensed/otf ../fonts/ArchivoExpanded/otf ../fonts/ArchivoExtraCondensed/otf ../fonts/ArchivoSemiCondensed/otf ../fonts/ArchivoSemiExpanded/otf

mkdir ../fonts/Archivo/otf ../fonts/ArchivoCondensed/otf ../fonts/ArchivoExpanded/otf ../fonts/ArchivoExtraCondensed/otf ../fonts/ArchivoSemiCondensed/otf ../fonts/ArchivoSemiExpanded/otf

mv $TT_DIR/Archivo*.otf ../fonts/Archivo/otf
mv $TT_DIR/ArchivoCondensed*.otf ../fonts/ArchivoCondensed/otf
mv $TT_DIR/ArchivoExpanded*.otf ../fonts/ArchivoExpanded/otf
mv $TT_DIR/ArchivoExtraCondensed*.otf ../fonts/ArchivoExtraCondensed/otf
mv $TT_DIR/ArchivoSemiCondensed*.otf ../fonts/ArchivoSemiCondensed/otf
mv $TT_DIR/ArchivoSemiExpanded*.otf ../fonts/ArchivoSemiExpanded/otf

##########################################


echo ".
COMPLETE!
."
