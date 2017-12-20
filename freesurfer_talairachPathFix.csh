#!/bin/csh

source ~/.cshrc

cd ${SUBJECTS_DIR}
foreach subject ( `ls -d ucsf_??` )
    pushd ${subject}/mri
    set xfmFile="${SUBJECTS_DIR}/${subject}/mri/transforms/talairach.xfm"
    if (-e $xfmFile) then
	echo $xfmFile
	foreach vol ( brain filled nu orig T1 wm )
	    #if (-e $vol/COR-.info) then
		#mri_add_xform_to_header -c $xfmFile $vol $vol
		mri_add_xform_to_header $xfmFile $vol $vol
	    #endif
	end
    else
	echo "File does not exist:"
	echo $xfmFile
    endif
    popd
end
