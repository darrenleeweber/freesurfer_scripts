#!/bin/csh

echo ""
echo "This is ~/bin/freesurfer csh script"
echo ""

setenv FREESURFER_HOME ~/freesurfer_home
#setenv MINC_BIN_DIR /netopt/freesurfer/pubsw/packages/mni/current/bin
#setenv MINC_LIB_DIR /netopt/freesurfer/pubsw/packages/mni/current/lib
setenv FSL_DIR ~/fsl_home

source $FREESURFER_HOME/FreeSurferEnv.csh

cd $SUBJECTS_DIR

xterm -ls -geometry 120x60 -title freesurfer &
