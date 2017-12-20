#!/bin/csh

cd $SUBJECTS_DIR

foreach sub ( `ls -d ucsf_??` )
    
    echo $sub
    
    # has this been done already?
    if ( -s $1/surf/lh.pial && -s $1/surf/rh.pial ) then
	echo "...the pial surfaces already exist."
    else
	echo "...running freesurfer recon-all."
	qsub -q dnl.q -l arch=lx24-x86 ~/bin/freesurfer_recon_bem_script.csh $sub &
    endif
end
