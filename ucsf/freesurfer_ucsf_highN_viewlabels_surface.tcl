
proc snapshots { subjTiffPrefix outputTiffPrefix } {

    global hemi

    puts "Taking Snapshots..."

    make_lateral_view
    rotate_brain_y 90
    redraw
    if { $hemi == "lh" } {
        puts "${subjTiffPrefix}_pos.tif"
        set tiff "${outputTiffPrefix}_pos.tif"
    } else {
        puts "${subjTiffPrefix}_ant.tif"
        set tiff "${outputTiffPrefix}_ant.tif"
    }
    save_tiff $tiff

    make_lateral_view
    rotate_brain_y 270
    redraw
    if { $hemi == "lh" } {
        puts "${subjTiffPrefix}_ant.tif"
        set tiff "${outputTiffPrefix}_ant.tif"
    } else {
        puts "${subjTiffPrefix}_pos.tif"
        set tiff "${outputTiffPrefix}_pos.tif"
    }
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

    restore_initial_position
    redraw

}



#set redrawlockflag 1

#move_window 0 0
#resize_window 1200
#restore_zero_position
#UpdateAndRedraw

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
set subjTiffPath  [ file join ${subjPath} tiff  ]

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
# load and display relevant .label files

# labelstyle, 0 filled, 1 outline
set labelstyle 0

set all 0
if $all {
    
    set labels [ glob -directory ${subjLabelPath} "DLWeber_${hemi}*.label" ]
    
} else {
    
    set labels {
	SFG MFG FEF
        LIP IPSa IPSv IPL
        Calc OccMid OccLat Fusiform 
    }
    
    #set labels { ACC ACCSMA FEF SEF SFG MFG FO
    #    IPL IPSa IPSp IPSv LIP SPL PCC 
    #    Calc OccLat OccMid Fusiform TEO STG }
    
    #CalcarineGinf 
    #CalcarineGsup
    #CalcarineS (sulcus)
    
}


# rainbow color mapping
#
#      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
#red    255  255  255  255  255  204  143   82   20     0     0     0     0
#green    0   61  122  184  245  255  255  255  255   255   255   255   255
#blue     0    0    0    0    0    0    0    0    0    41   102   163   224
#      [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24] [,25]
#red       0     0     0     0    20    82   143   204   255   255   255   255
#green   224   163   102    41     0     0     0     0     0     0     0     0
#blue    255   255   255   255   255   255   255   255   245   184   122    61

set r 1
set g 2
set b 3

set useRed 1
if $useRed {
    
    set x 0
    foreach l $labels {
        
        set colors($x,$r) 255
        set colors($x,$g)   0
        set colors($x,$b)   0
        
        set x [expr $x + 1]
    }

} else {
    
    # set colors from /usr/lib/X11/rgb.txt

    # 255   0   0             red
    set colors(0,$r) 255
    set colors(0,$g)   0
    set colors(0,$b)   0
    # 255 240 245             LavenderBlush
    set colors(1,$r) 255
    set colors(1,$g) 240
    set colors(1,$b) 245
    #   0   0 128             NavyBlue
    set colors(2,$r)   0
    set colors(2,$g)   0
    set colors(2,$b) 128
    # 255 255   0             yellow
    set colors(3,$r) 255
    set colors(3,$g) 255
    set colors(3,$b)   0
    # 145  44 238             purple2
    set colors(4,$r) 145
    set colors(4,$g)  44
    set colors(4,$b) 238
    # 255 140   0             DarkOrange
    set colors(5,$r) 255
    set colors(5,$g) 140
    set colors(5,$b)   0
    # 208  32 144             violet red
    set colors(6,$r) 208
    set colors(6,$g)  32
    set colors(6,$b) 144
    # 255 245 238             seashell
    set colors(7,$r) 255
    set colors(7,$g) 245
    set colors(7,$b) 238
    # 255  69   0             orange red
    set colors(8,$r) 255
    set colors(8,$g)  69
    set colors(8,$b)   0
    # 255 228 225             MistyRose
    set colors(9,$r) 255
    set colors(9,$g) 228
    set colors(9,$b) 225
    # 244 164  96             SandyBrown
    set colors(10,$r) 244
    set colors(10,$g) 164
    set colors(10,$b)  96
    # 205  96 144             HotPink3
    set colors(11,$r) 205
    set colors(11,$g)  96
    set colors(11,$b) 144
    # 139   0   0             dark red
    set colors(12,$r) 139
    set colors(12,$g)   0
    set colors(12,$b)   0
    # 255 255   0             yellow
    set colors(13,$r) 255
    set colors(13,$g) 255
    set colors(13,$b)   0
    # 102 205 170             MediumAquamarine
    set colors(14,$r) 102
    set colors(14,$g) 205
    set colors(14,$b) 170
    #   0 191 255             DeepSkyBlue
    set colors(15,$r)   0
    set colors(15,$g) 191
    set colors(15,$b) 255
    # 139  69  19             SaddleBrown
    set colors(16,$r) 139
    set colors(16,$g)  69
    set colors(16,$b)  19
    # 238  99  99             IndianRed2
    set colors(17,$r) 238
    set colors(17,$g)  99
    set colors(17,$b)  99
    # 184 134  11             DarkGoldenrod
    set colors(18,$r) 184
    set colors(18,$g) 134
    set colors(18,$b)  11
    # 221 160 221             plum
    set colors(19,$r) 221
    set colors(19,$g) 160
    set colors(19,$b) 221
    #  25  25 112             MidnightBlue
    set colors(20,$r)  25
    set colors(20,$g)  25
    set colors(20,$b) 152
    # 255  69   0             OrangeRed
    set colors(21,$r) 255
    set colors(21,$g)  69
    set colors(21,$b)   0
    # 154 205  50             YellowGreen
    set colors(22,$r) 184
    set colors(22,$g) 205
    set colors(22,$b)  50
    #  95 158 160             CadetBlue
    set colors(23,$r)  95
    set colors(23,$g) 158
    set colors(23,$b) 160
    # 175 238 238             PaleTurquoise
    set colors(24,$r) 175
    set colors(24,$g) 238
    set colors(24,$b) 238

}


# -----------------------------------------------
# load the labels and set their colors
set x 0
foreach l $labels {
    puts "loading ${subject}/label/DLWeber_surface_${hemi}_$l"
    labl_load [file join $subjLabelPath "DLWeber_surface_${hemi}_$l"]
    #labl_set_info $x $l $x 1
    
    #labl_set_color label red green blue
    labl_set_color $x $colors($x,$r) $colors($x,$g) $colors($x,$b)
    set x [expr $x + 1]
}

# -----------------------------------------------
# list the labels and their colors
set x 0
foreach l $labels {
    puts "$l $colors($x,$r) $colors($x,$g) $colors($x,$b)"
    set x [expr $x + 1]
}
select_vertex_by_vno 1
clear_all_vertex_marks
clear_vertex_marks

# -----------------------------------------------
# save graphics of the labels

set subjTiffPrefix ${subject}_surface_${hemi}_${ext}_labels
set outputTiffPrefix [ file join ${subjTiffPath} ${subjTiffPrefix} ]

snapshots $subjTiffPrefix $outputTiffPrefix

exit
