#!/bin/sh
# the next line restarts using tclsh \
#exec tclsh "$0" "$@"

set FREESURFER_HOME "/home/dweber/freesurfer/home"
set SUBJECTS_DIR "/home/dweber/freesurfer/subjects"

set subjects [ glob -directory ${SUBJECTS_DIR} "ucsf_??" ]
set subjects [ lsort $subjects ]

set surfaces {inflated pial}

foreach subject $subjects {

    if ![ file isdirectory $subject ] {
	continue
    }
    
    set subjID [ file tail $subject ]
    
    puts $subjID

    set subjPath [ file join ${SUBJECTS_DIR} ${subjID} ]

    set subjSurfPath  [ file join ${subjPath} surf  ]
    set subjTiffPath  [ file join ${subjPath} rgb   ]

    foreach h {lh rh} {

	set insurf [file join ${subjSurfPath} ${h}.orig ]
	read_binary_surf

	foreach surf $surfaces {

	    # -----------------------------------------------
	    # load the surface, with curvature
	    
	    # this invocation doesn't work
	    #tksurfer -$subjID $h $surf
	    
	    
	    # Read a set of vertices from fileName. 
	    # 'field' should be one of the following:
	    #
	    # 0 	Main vertices
	    # 1 	Inflated vertices
	    # 2 	White vertices
	    # 3 	Pial vertices
	    # 4 	Orig vertices
	    switch $surf {
		main     {set field 0}
		inflated {set field 1}
		white    {set field 2}
		pial     {set field 3}
		orig     {set field 4}
		default  {set field 0}
	    }

	    set insurf [file join ${subjSurfPath} ${h}.${surf} ]
	    read_binary_surf
	    read_surface_vertex_set $field $insurf
	    redraw
	    
	    set curv [file join ${subjSurfPath} ${h}.curv]
	    read_binary_curv

	    UpdateAndRedraw
	    
	    # -----------------------------------------------
	    # save graphics of the surface

	    set subjTiffPrefix ${subjID}_${h}_${surf}
	    set subjTiffPrefix [ file join ${subjTiffPath} ${subjTiffPrefix} ]
	    
	    UpdateAndRedraw
	    puts "Taking Snapshots..."
	    make_lateral_view
	    rotate_brain_y 90
	    redraw
	    set tiff "${subjTiffPrefix}_pos.tif"
	    save_tiff $tiff
	    make_lateral_view
	    redraw
	    set tiff "${subjTiffPrefix}_lat.tif"
	    save_tiff $tiff
	    rotate_brain_y 180
	    redraw
	    set tiff "${subjTiffPrefix}_med.tif"
	    save_tiff $tiff
	    make_lateral_view
	    rotate_brain_x 90
	    redraw
	    set tiff "${subjTiffPrefix}_inf.tif"
	    save_tiff $tiff
	    rotate_brain_x 180
	    redraw
	    set tiff "${subjTiffPrefix}_sup.tif"
	    save_tiff $tiff
	    make_lateral_view
	    rotate_brain_y 270
	    redraw
	    set tiff "${subjTiffPrefix}_ant.tif"
	    save_tiff $tiff

	    # exit this tksurfer
	    #exit
	}
    }
}

# exit tclsh
exit
