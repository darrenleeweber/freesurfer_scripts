
# These are inherited from tksurfer
puts $subject
puts $hemi
puts $ext

# -----------------------------------------------
# setup paths

set FREESURFER_HOME $env(FREESURFER_HOME)
set SUBJECTS_DIR $env(SUBJECTS_DIR)

set subjPath [ file join ${SUBJECTS_DIR} ${subject} ]

set subjSurfPath  [ file join ${subjPath} surf  ]
set subjLabelPath [ file join ${subjPath} label ]
set subjTiffPath  [ file join ${subjPath} rgb   ]

# -----------------------------------------------
# load the surface, with curvature

# Read a set of vertices from fileName into
# $field, which should be one of the following:
switch $ext {
    main     {set field 0}
    inflated {set field 1}
    white    {set field 2}
    pial     {set field 3}
    orig     {set field 4}
    default  {set field 0}
}
set insurf [file join ${subjSurfPath} ${hemi}.${ext} ]
#read_binary_surf
read_surface_vertex_set $field $insurf
UpdateAndRedraw

set curv [file join ${subjSurfPath} ${hemi}.curv]
read_binary_curv
UpdateAndRedraw


# -----------------------------------------------
# save graphics

set subjTiffPrefix ${subject}_${hemi}_${ext}
set outputTiffPrefix [ file join ${subjTiffPath} ${subjTiffPrefix} ]

UpdateAndRedraw
puts "Taking Snapshots..."
make_lateral_view
rotate_brain_y 90
redraw
puts "${subjTiffPrefix}_pos.tif"
set tiff "${outputTiffPrefix}_pos.tif"
save_tiff $tiff
make_lateral_view
redraw
puts "${subjTiffPrefix}_lat.tif"
set tiff "${outputTiffPrefix}_lat.tif"
save_tiff $tiff
rotate_brain_y 180
redraw
puts "${subjTiffPrefix}_med.tif"
set tiff "${outputTiffPrefix}_med.tif"
save_tiff $tiff
make_lateral_view
rotate_brain_x 90
redraw
puts "${subjTiffPrefix}_inf.tif"
set tiff "${outputTiffPrefix}_inf.tif"
save_tiff $tiff
rotate_brain_x 180
redraw
puts "${subjTiffPrefix}_sup.tif"
set tiff "${outputTiffPrefix}_sup.tif"
save_tiff $tiff
make_lateral_view
rotate_brain_y 270
redraw
puts "${subjTiffPrefix}_ant.tif"
set tiff "${outputTiffPrefix}_ant.tif"
save_tiff $tiff

exit
