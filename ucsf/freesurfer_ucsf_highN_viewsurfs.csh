#!/bin/csh

source ~/.cshrc

cd $SUBJECTS_DIR

set surfaces=(inflated pial)

foreach subject (`ls -d ucsf_??`)

    if !( -d $subject ) continue;
    
    echo $subject

    foreach hemi (lh rh)

	foreach surf ($surfaces)

	    tksurfer -$subject ${hemi} ${surf} -tcl ~/bin/freesurfer_ucsf_hin_viewsurfs.tcl
	end
    end
end

exit
