
#setfile val *//

#setfile patch ~/surf/rh.patch
# write_binary_patch

open_window
move_window 600 0
resize_window 400

redraw

#compute_curvature
#setfile curv ~/surf/rh.smoothwm.curv
#write_binary_curv
#read_binary_curv

make_lateral_view
set cslope 1.2

redraw


# This ascii file contains all the locations of
# the vertices in the tesselation
setfile dip ~/surf/rh.smoothwm.dip
write_dipoles

exit


# compute_select_fwd <maxdist (mm)>  ??????

#subsample_orient <orientthresh[0.03]>
#subsample_orient 0.03

#subsample_dist <mm>
subsample_dist 5
# This ascii file contains all the vertices of the subsample,
# with their vertex number from the full tesselation
setfile dec ~/surf/rh.smoothwm.05mm.vert
write_subsample
# This ascii file contains 0/1 for each full tesselation vertex,
# with 1 indicating that the vertex is in the subsample
setfile dec ~/surf/rh.smoothwm.05mm.dec
write_decimation


exit
