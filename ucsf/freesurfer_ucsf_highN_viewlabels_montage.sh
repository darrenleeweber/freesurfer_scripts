#!/bin/bash

# imagemagick /usr/share/doc/imagemagick


echo $0 $1

if [ "$1" == "" ]; then
    echo "Useage: $0 <subjectID>"
    exit
fi

subject=`basename $1`

FS_SUBJECTS=~/freesurfer/subjects

cd $FS_SUBJECTS

if [ -d $subject ]; then
    echo $subject is a subject directory in $FS_SUBJECTS
else
    echo $subject is not a subject directory in $FS_SUBJECTS
    exit
fi

tiffPath=$FS_SUBJECTS/$subject/tiff

cd $tiffPath

mkdir -p tmp

doConvert="YES"
if [ "$doConvert" == "YES" ]; then

    echo "converting tif to png"
    
    for f in *ant.tif; do
        prefix=`echo $f | sed s/ant.tif//g`
        echo $prefix
        
        convert -trim ${prefix}ant.tif tmp/${prefix}ant.png
        convert -trim ${prefix}pos.tif tmp/${prefix}pos.png
        convert -trim ${prefix}med.tif tmp/${prefix}med.png
        convert -trim ${prefix}lat.tif tmp/${prefix}lat.png
        convert -trim ${prefix}inf.tif tmp/${prefix}inf.png
        convert -trim ${prefix}sup.tif tmp/${prefix}sup.png
    done
fi

cd tmp

echo "creating montages"

for f in *ant.png; do
    
    prefix=`echo $f | sed s/ant.png//g`
    echo $prefix
    
    #  -transparent "#000000"

    montage -background "#000000" \
        -mode Concatenate \
        -fill white -pointsize 28 \
        -label "Posterior" ${prefix}pos.png tmp_pos.png
    
    montage -background "#000000" \
        -mode Concatenate \
        -fill white -font times -pointsize 28 \
        -label "Anterior" ${prefix}ant.png tmp_ant.png
    
    montage -background "#000000" \
	-mode Concatenate \
	-tile 2x1 tmp_ant.png tmp_pos.png tmp_antpos.png
    
    montage -background "#000000" \
	-mode Concatenate \
	-tile 2x1 ${prefix}lat.png ${prefix}med.png tmp_latmed.png
    
    mogrify -flop ${prefix}inf.png
    montage -background "#000000" \
	-mode Concatenate \
	-tile 2x1 ${prefix}sup.png ${prefix}inf.png -geometry +2+2 tmp_supinf.png

    montage -background "#000000" \
        -mode Concatenate \
	-tile 1x2 tmp_latmed.png tmp_supinf.png tmp1.png
    
    montage -background "#000000" \
	-mode Concatenate \
	tmp_antpos.png tmp1.png tmp_final.png
    
    convert -trim tmp_final.png ${prefix}all.png
    
    mv ${prefix}all.png ..
    
    rm tmp*.png
    
done

cd ..
rm -rf tmp
