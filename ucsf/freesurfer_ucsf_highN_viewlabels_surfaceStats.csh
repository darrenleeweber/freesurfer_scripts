#!/bin/csh

source ~/.cshrc

cd $SUBJECTS_DIR

echo $0 $1

if ("$1" == "") then
    echo "Useage: $0 <subjectID>"
    exit
endif

set subject=`basename $1`

setenv FS_SUBJECTS ~/freesurfer/subjects

cd $FS_SUBJECTS

if ( -d $subject ) then
    echo $subject is a subject directory in $FS_SUBJECTS
else
    echo $subject is not a subject directory in $FS_SUBJECTS
    exit
endif

#set subjects `ls -d ucsf_??`
#echo $subjects

set surfaces=(inflated pial)

foreach hemi (lh rh)
  foreach surf ($surfaces)
    tksurfer -$subject ${hemi} ${surf} \
        -tcl ~/bin/freesurfer_ucsf_highN_viewlabels_surfaceStats.tcl
  end
end

exit
