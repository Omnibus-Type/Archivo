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

rm -rf ../fonts/Archivo/Archivo/ttf ../fonts/Archivo/ArchivoCondensed/ttf ../fonts/Archivo/ArchivoExpanded/ttf ../fonts/Archivo/ArchivoExtraCondensed/ttf ../fonts/Archivo/ArchivoSemiCondensed/ttf ../fonts/Archivo/ArchivoSemiExpanded/ttf

mkdir ../fonts/Archivo/Archivo/ttf ../fonts/Archivo/ArchivoCondensed/ttf ../fonts/Archivo/ArchivoExpanded/ttf ../fonts/Archivo/ArchivoExtraCondensed/ttf ../fonts/Archivo/ArchivoSemiCondensed/ttf ../fonts/Archivo/ArchivoSemiExpanded/ttf

mv $TT_DIR/Archivo*.ttf ../fonts/Archivo/Archivo/ttf
mv $TT_DIR/ArchivoCondensed*.ttf ../fonts/Archivo/ArchivoCondensed/ttf
mv $TT_DIR/ArchivoExpanded*.ttf ../fonts/Archivo/ArchivoExpanded/ttf
mv $TT_DIR/ArchivoExtraCondensed*.ttf ../fonts/Archivo/ArchivoExtraCondensed/ttf
mv $TT_DIR/ArchivoSemiCondensed*.ttf ../fonts/Archivo/ArchivoSemiCondensed/ttf
mv $TT_DIR/ArchivoSemiExpanded*.ttf ../fonts/Archivo/ArchivoSemiExpanded/ttf

echo ".
MOVING OTF
."

rm -rf ../fonts/Archivo/Archivo/otf ../fonts/Archivo/ArchivoCondensed/otf ../fonts/Archivo/ArchivoExpanded/otf ../fonts/Archivo/ArchivoExtraCondensed/otf ../fonts/Archivo/ArchivoSemiCondensed/otf ../fonts/Archivo/ArchivoSemiExpanded/otf

mkdir ../fonts/Archivo/Archivo/otf ../fonts/Archivo/ArchivoCondensed/otf ../fonts/Archivo/ArchivoExpanded/otf ../fonts/Archivo/ArchivoExtraCondensed/otf ../fonts/Archivo/ArchivoSemiCondensed/otf ../fonts/Archivo/ArchivoSemiExpanded/otf

mv $TT_DIR/Archivo*.otf ../fonts/Archivo/Archivo/otf
mv $TT_DIR/ArchivoCondensed*.otf ../fonts/Archivo/ArchivoCondensed/otf
mv $TT_DIR/ArchivoExpanded*.otf ../fonts/Archivo/ArchivoExpanded/otf
mv $TT_DIR/ArchivoExtraCondensed*.otf ../fonts/Archivo/ArchivoExtraCondensed/otf
mv $TT_DIR/ArchivoSemiCondensed*.otf ../fonts/Archivo/ArchivoSemiCondensed/otf
mv $TT_DIR/ArchivoSemiExpanded*.otf ../fonts/Archivo/ArchivoSemiExpanded/otf

##########################################


echo ".
COMPLETE!
."
