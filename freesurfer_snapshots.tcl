# freesurfer_snapshot.tcl
#
# tcl script for making pics using tksurfer.
#
# This script automates a set of tksurfer commands.
#
# Be sure to check the base directory and the
# regular expression before running!
#
# Pictures will be put in the images directory
# underneath the basedir.
#
# You may also want to adjust the thresholds
# and lighting models.
#
# glenn, sept 2005
##########################################

# To use: Set all the parameters and then
# pass the script as an argument to tksurfer
# for example:
#
# tksurfer average7 lh inflated \
#          -tcl freesurfer_snapshots.tcl
#


# The basedir is where all the w files are found
# You probably need to set this to the correct value
set basedir "/home/dweber/freesurfer/"


# Use a regular expression to find all of the
# *.w files for each hemisphere
foreach wfile [glob ${hemi}*.w] {        
    # read the wfile
    set layr 0
    set val "${basedir}/${wfile}"
    sclv_read_binary_values $layr

    # set thresholds for the overlay
    # and values for the lighting model
    set fthresh 1
    set fslope 1
    set fmid 2
    do_lighting_model 0.6 0.9 0.6 0.2 0.4;


    #   Make and save .rgb images
    set cnt 1
    set imagename [string trim $wfile .w]
    set filestem "/${basedir}/images/${imagename}"
    puts "Taking Snapshots for $filestem";

    make_lateral_view; # sets to default orientation
    redraw;
    set filestem "/${basedir}/images/${cnt}_${imagename}"
    setfile rgb "${filestem}.rgb";
    puts $rgb;
    save_rgb;
    
    # rotate up
    set i 0 
    while {$i < 110} {
	rotate_brain_x -1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # rotate down/towards
    set i 0
    while {$i < 90} {
	rotate_brain_x 1;
	rotate_brain_y -1;
	rotate_brain_z 1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # rotate down/away
    set i 0
    while {$i < 20} {
	rotate_brain_x -1;
	rotate_brain_y 1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # rotate away
    make_lateral_view;
    rotate_brain_y -90;
    set i 0 
    set j 0
    while {$i < 100} {
	rotate_brain_y 2;
	if {$j < 20 && $j > -1} {
	    rotate_brain_x 1;
	    rotate_brain_z -1;}
	if {$j >= 30 && $j < 50} {
	    rotate_brain_x -1;
	    rotate_brain_z 1;}
	if {$j == 60} {
	    set j -10;}
	if {$i > 79} { set j 3}
	incr j 1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # rotate up
    set i 0
    while {$i < 40} {
	rotate_brain_x 1;
	rotate_brain_y -1;
	rotate_brain_z -1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # rotate up
    set i 0
    while {$i < 40} {
	#	rotate_brain_x -1;
	rotate_brain_y -1;
	rotate_brain_z -1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
    # and back home
    #set i 0
    while {$i < 90} {
	rotate_brain_x -1;
	#	rotate_brain_y -1;
	rotate_brain_z -1;
	incr i 1;
	incr cnt 1;
	redraw;
	set filestem "/${basedir}/images/${cnt}_${imagename}"
	setfile rgb "${filestem}.rgb";
	puts $rgb;
	save_rgb;
    }
}
exit
