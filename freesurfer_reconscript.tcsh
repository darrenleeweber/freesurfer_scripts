#/bin/tcsh
#########################################################
# super-recon
#
# This script will run all of the recon-all -all options
#
#
########################################################

source /usr/local/freesurfer/nmr-dev-env

######################################################
# EDIT THIS STUFF
#
setenv SUBJECTS_DIR /space/your/subject/dir
setenv SUBJECT subject_37237_or_whatever
setenv MYMAIL your_email@somewhere.com
setenv invol1 /space/your/orig/dicom/file1
setenv invol2 /space/your/orig/dicom/file2

######################################################

cd $SUBJECTS_DIR

############################################################
#
# Be sure to comment out any step you don't want to do here
# but if you do that, also get rid of the waitfor option that will prevent the
# next step from running.
#
##############################################################

setenv DIR $SUBJECTS_DIR/$SUBJECT/recon_notifiers
setenv LOG $SUBJECTS_DIR/$SUBJECT/scripts/recon-all.log
setenv STAT $SUBJECTS_DIR/$SUBJECT/scrips/recon-all-status.log
recon-all -s $SUBJECT -i $invol1 -i $invol2 -notify $DIR/step1-00.done -log $LOG -status $STAT &
recon-all -s $SUBJECT -notify $DIR/step1-01.done -waitfor $DIR/step1-00.done -log $LOG -status $STAT -motioncor &
recon-all -s $SUBJECT -notify $DIR/step1-02.done -waitfor $DIR/step1-01.done -log $LOG -status $STAT -nuintensitycor &
recon-all -s $SUBJECT -notify $DIR/step1-03.done -waitfor $DIR/step1-02.done -log $LOG -status $STAT -talairach &
recon-all -s $SUBJECT -notify $DIR/step1-04.done -waitfor $DIR/step1-03.done -log $LOG -status $STAT -normalization &
recon-all -s $SUBJECT -notify $DIR/step1-05.done -waitfor $DIR/step1-04.done -log $LOG -status $STAT -skullstrip &
recon-all -s $SUBJECT -notify $DIR/step2-01.done -waitfor $DIR/step1-05.done -log $LOG -status $STAT -gcareg &
recon-all -s $SUBJECT -notify $DIR/step2-02.done -waitfor $DIR/step2-01.done -log $LOG -status $STAT -canorm &
recon-all -s $SUBJECT -notify $DIR/step2-03.done -waitfor $DIR/step2-02.done -log $LOG -status $STAT -careg &
recon-all -s $SUBJECT -notify $DIR/step2-04.done -waitfor $DIR/step2-03.done -log $LOG -status $STAT -rmneck &
recon-all -s $SUBJECT -notify $DIR/step2-05.done -waitfor $DIR/step2-04.done -log $LOG -status $STAT -skull-lta &
recon-all -s $SUBJECT -notify $DIR/step2-06.done -waitfor $DIR/step2-05.done -log $LOG -status $STAT -calabel &
recon-all -s $SUBJECT -notify $DIR/step2-07.done -waitfor $DIR/step2-06.done -log $LOG -status $STAT -segstats &
recon-all -s $SUBJECT -notify $DIR/step2-08.done -waitfor $DIR/step2-07.done -log $LOG -status $STAT -normalization2 &
recon-all -s $SUBJECT -notify $DIR/step2-09.done -waitfor $DIR/step2-08.done -log $LOG -status $STAT -segmentation &
recon-all -s $SUBJECT -notify $DIR/step2-10.done -waitfor $DIR/step2-09.done -log $LOG -status $STAT -fill &

setenv hemi lh
setenv LOG $SUBJECTS_DIR/$SUBJECT/scripts/recon-all-${hemi}.log
setenv STAT $SUBJECTS_DIR/$SUBJECT/scrips/recon-all-status-${hemi}.log
recon-all -s $SUBJECT -notify $DIR/step2-10${hemi}.done -waitfor $DIR/step2-09.done -log $LOG -status $STAT       -tessellate -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-11${hemi}.done -waitfor $DIR/step2-10${hemi}.done -log $LOG -status $STAT-smooth1 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-12${hemi}.done -waitfor $DIR/step2-11${hemi}.done -log $LOG -status $STAT-inflate1 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-13${hemi}.done -waitfor $DIR/step2-12${hemi}.done -log $LOG -status $STAT-qsphere -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-14${hemi}.done -waitfor $DIR/step2-13${hemi}.done -log $LOG -status $STAT-fix -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-15${hemi}.done -waitfor $DIR/step2-14${hemi}.done -log $LOG -status $STAT-finalsurfs -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-16${hemi}.done -waitfor $DIR/step2-15${hemi}.done -log $LOG -status $STAT-smooth2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-17${hemi}.done -waitfor $DIR/step2-16${hemi}.done -log $LOG -status $STAT-inflate2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-18${hemi}.done -waitfor $DIR/step2-17${hemi}.done -log $LOG -status $STAT-cortribbon -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-01${hemi}.done -waitfor $DIR/step2-18${hemi}.done -log $LOG -status $STAT-sphere -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-02${hemi}.done -waitfor $DIR/step3-01${hemi}.done -log $LOG -status $STAT-surfreg -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-03${hemi}.done -waitfor $DIR/step3-02${hemi}.done -log $LOG -status $STAT-contrasurfreg -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-04${hemi}.done -waitfor $DIR/step3-03${hemi}.done -log $LOG -status $STAT-avgcurv -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-05${hemi}.done -waitfor $DIR/step3-04${hemi}.done -log $LOG -status $STAT-cortparc -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-06${hemi}.done -waitfor $DIR/step3-05${hemi}.done -log $LOG -status $STAT-parcstats -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-07${hemi}.done -waitfor $DIR/step3-06${hemi}.done -log $LOG -status $STAT-cortparc2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-08${hemi}.done -waitfor $DIR/step3-07${hemi}.done -log $LOG -status $STAT-parcstats2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-09${hemi}.done -waitfor $DIR/step3-08${hemi}.done -log $LOG -status $STAT -mail $MYMAIL -aparc2aseg -hemi $hemi &

setenv hemi rh
setenv LOG $SUBJECTS_DIR/$SUBJECT/scripts/recon-all-${hemi}.log
setenv STAT $SUBJECTS_DIR/$SUBJECT/scrips/recon-all-status-${hemi}.log
recon-all -s $SUBJECT -notify $DIR/step2-10${hemi}.done -waitfor $DIR/step2-09.done -log $LOG -status $STAT        -tessellate -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-11${hemi}.done -waitfor $DIR/step2-10${hemi}.done -log $LOG -status $STAT -smooth1 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-12${hemi}.done -waitfor $DIR/step2-11${hemi}.done -log $LOG -status $STAT -inflate1 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-13${hemi}.done -waitfor $DIR/step2-12${hemi}.done -log $LOG -status $STAT -qsphere -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-14${hemi}.done -waitfor $DIR/step2-13${hemi}.done -log $LOG -status $STAT -fix -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-15${hemi}.done -waitfor $DIR/step2-14${hemi}.done -log $LOG -status $STAT -finalsurfs -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-16${hemi}.done -waitfor $DIR/step2-15${hemi}.done -log $LOG -status $STAT -smooth2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-17${hemi}.done -waitfor $DIR/step2-16${hemi}.done -log $LOG -status $STAT -inflate2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step2-18${hemi}.done -waitfor $DIR/step2-17${hemi}.done -log $LOG -status $STAT -cortribbon -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-01${hemi}.done -waitfor $DIR/step2-18${hemi}.done -log $LOG -status $STAT -sphere -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-02${hemi}.done -waitfor $DIR/step3-01${hemi}.done -log $LOG -status $STAT -surfreg -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-03${hemi}.done -waitfor $DIR/step3-02${hemi}.done -log $LOG -status $STAT -contrasurfreg -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-04${hemi}.done -waitfor $DIR/step3-03${hemi}.done -log $LOG -status $STAT -avgcurv -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-05${hemi}.done -waitfor $DIR/step3-04${hemi}.done -log $LOG -status $STAT -cortparc -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-06${hemi}.done -waitfor $DIR/step3-05${hemi}.done -log $LOG -status $STAT -parcstats -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-07${hemi}.done -waitfor $DIR/step3-06${hemi}.done -log $LOG -status $STAT -cortparc2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-08${hemi}.done -waitfor $DIR/step3-07${hemi}.done -log $LOG -status $STAT -parcstats2 -hemi $hemi &
recon-all -s $SUBJECT -notify $DIR/step3-09${hemi}.done -waitfor $DIR/step3-08${hemi}.done -log $LOG -status $STAT -mail $MYMAIL -aparc2aseg -hemi $hemi &
