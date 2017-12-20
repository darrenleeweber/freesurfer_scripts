

# -----------------------------------------------
# setup paths

set FREESURFER_HOME $env(FREESURFER_HOME)
set SUBJECTS_DIR $env(SUBJECTS_DIR)

set subjPath [ file join ${SUBJECTS_DIR} $subject ]

set subjSurfPath  [ file join $subjPath surf  ]
set subjLabelPath [ file join $subjPath label ]
set subjTiffPath  [ file join $subjPath rgb   ]


set redrawlockflag 1

#source ~/bin/freesurfer_resize_window.tcl

update idletasks

after idle { mapLabels }

proc mapLabels {} {

    global subject hemi ext
    
    global subjSurfPath subjLabelPath subjTiffPath
    
    # These are inherited from tksurfer
    puts $subject
    puts $hemi
    puts $ext
    
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
    redraw
    
    set curv [file join ${subjSurfPath} ${hemi}.curv]
    read_binary_curv
    redraw
    
    UpdateAndRedraw
    


    # -----------------------------------------------
    # load and display relevant .label files

    # labelstyle, 0 filled, 1 outline
    set labelstyle 0

    set all 0
    if $all {		
        set labels [ glob -directory ${subjLabelPath} "DLWeber_${hemi}*.label" ]
        foreach l $labels { labl_load $l }
    } else {
        
        set labels { ACC ACCSMA FEF SEF SFG MFG FO
            IPL IPSa IPSp IPSv LIP SPL PCC 
            CalcarineGsup OccLat OccMid Fusiform TEO STG }
        #CalcarineGinf 
        #CalcarineS


        # Setup a color map for p values
        
        #      p<.001, <.01, <.05, <.1
        #      red, orange, brown, yellow
        #      [,1] [,2] [,3] [,4]
        #red    240  253  254  255
        #green   59  141  204  255
        #blue    32   60   92  178
        
        set r 1
        set g 2
        set b 3
        set rgb [list $r $g $b]
        
        array set pNotSig     [list $r 250 $g 250 $b 250]
        array set pLTpoint1   [list $r 255 $g 255 $b 178]
        array set pLTpoint05  [list $r 254 $g 204 $b  92]
        array set pLTpoint01  [list $r 253 $g 141 $b  60]
        array set pLTpoint001 [list $r 240 $g  59 $b  32]

        # ANOVA effects to visualize
        set effects { hemi cueXhemi }

        foreach effect $effects {

            set timeWindows {100 200 300 700}
            
            foreach timeWindow $timeWindows {
                

                
                # initialize all labels
                foreach l $labels {
                    set pmap($l,$r) $pNotSig($r)
                    set pmap($l,$g) $pNotSig($g)
                    set pmap($l,$b) $pNotSig($b)
                }

                if {$effect == "hemi"} {
                    
                    if {$timeWindow == 100} {
                        foreach c $rgb {
                            set pmap(ACC,$c)    $pLTpoint05($c)
                            set pmap(ACCSMA,$c) $pLTpoint05($c)
                            
                            set pmap(SEF,$c)    $pLTpoint05($c)
                            set pmap(FEF,$c)    $pLTpoint01($c)
                            
                            set pmap(LIP,$c)    $pLTpoint05($c)
                            set pmap(IPSv,$c)   $pLTpoint05($c)
                            set pmap(IPL,$c)    $pLTpoint05($c)
                            
                            set pmap(STG,$c)    $pLTpoint05($c)
                            set pmap(OccLat,$c) $pLTpoint05($c)
                            set pmap(CalcarineGsup,$c) $pLTpoint05($c)
                        }
                    }
                    if {$timeWindow == 200} {
                        foreach c $rgb {
                            
                            set pmap(FEF,$c)    $pLTpoint05($c)
                            
                            set pmap(SPL,$c)    $pLTpoint001($c)
                            
                            set pmap(LIP,$c)    $pLTpoint05($c)
                            
                            set pmap(IPSa,$c)   $pLTpoint001($c)
                            set pmap(IPSp,$c)   $pLTpoint001($c)
                            set pmap(IPSv,$c)   $pLTpoint01($c)
                            
                            set pmap(OccMid,$c) $pLTpoint05($c)
                        }	    
                    }
                    if {$timeWindow == 300} {
                        foreach c $rgb {
                            
                            set pmap(ACC,$c)    $pLTpoint05($c)
                            set pmap(ACCSMA,$c) $pLTpoint05($c)
                            
                            set pmap(MFG,$c)    $pLTpoint01($c)

                            set pmap(IPSp,$c)   $pLTpoint05($c)
                            set pmap(STG,$c)    $pLTpoint05($c)

                            set pmap(OccLat,$c) $pLTpoint1($c)
                            set pmap(OccMid,$c) $pLTpoint05($c)
                        }
                    }	
                    if {$timeWindow == 700} {
                        foreach c $rgb {
                            
                            set pmap(SEF,$c)    $pLTpoint1($c)
                            set pmap(FEF,$c)    $pLTpoint05($c)

                            set pmap(IPSa,$c)   $pLTpoint05($c)
                            set pmap(IPSv,$c)   $pLTpoint05($c)

                            set pmap(OccLat,$c) $pLTpoint05($c)
                            set pmap(OccMid,$c) $pLTpoint05($c)	
                            set pmap(Fusiform,$c) $pLTpoint001($c)
                        }
                    }	
                }
                
                if {$effect == "cueXhemi"} {
                    
                    if {$timeWindow == 100} {
                        foreach c $rgb {

                            set pmap(ACC,$c) $pLTpoint05($c)
                            
                            set pmap(SPL,$c)  $pLTpoint05($c)
                            set pmap(IPSv,$c) $pLTpoint05($c)

                            set pmap(OccMid,$c) $pLTpoint05($c)
                            
                            set pmap(CalcarineGsup,$c) $pLTpoint1($c)
                            set pmap(TEO,$c) $pLTpoint1($c)
                        }
                    }
                    if {$timeWindow == 200} {
                        foreach c $rgb {

                            set pmap(ACC,$c) $pLTpoint1($c)
                            set pmap(ACCSMA,$c) $pLTpoint1($c)

                            set pmap(MFG,$c) $pLTpoint1($c)

                            set pmap(LIP,$c) $pLTpoint1($c)

                            set pmap(STG,$c) $pLTpoint1($c)

                            set pmap(OccMid,$c) $pLTpoint1($c)
                            set pmap(Fusiform,$c) $pLTpoint1($c)
                        }
                    }
                    if {$timeWindow == 300} {
                        foreach c $rgb {

                            set pmap(MFG,$c) $pLTpoint05($c)
                            
                            set pmap(SEF,$c) $pLTpoint05($c)
                            set pmap(FEF,$c) $pLTpoint01($c)

                            set pmap(IPSv,$c) $pLTpoint1($c)

                            set pmap(OccMid,$c) $pLTpoint05($c)
                            set pmap(Fusiform,$c) $pLTpoint05($c)
                        }
                    }
                    if {$timeWindow == 700} {
                        foreach c $rgb {

                            set pmap(ACCSMA,$c) $pLTpoint1($c)

                            set pmap(MFG,$c) $pLTpoint05($c)
                            set pmap(SEF,$c) $pLTpoint05($c)

                            set pmap(LIP,$c) $pLTpoint01($c)
                            set pmap(IPSp,$c) $pLTpoint01($c)
                            set pmap(IPSv,$c) $pLTpoint001($c)

                            set pmap(CalcarineGsup,$c) $pLTpoint05($c)
                            set pmap(OccLat,$c) $pLTpoint05($c)
                            set pmap(OccMid,$c) $pLTpoint001($c)

                            set pmap(Fusiform,$c) $pLTpoint1($c)
                            set pmap(TEO,$c) $pLTpoint05($c)
                        }
                    }
                }
                
                parray pmap
                
                set labelN 0
                foreach labelName $labels {

                    # only load the labels with any significant activity
                    if { $pmap($labelName,$r) != $pNotSig($r) } {
                        
                        puts "loading ${subject}/label/DLWeber_${hemi}_$labelName"
                        labl_load [file join $subjLabelPath "DLWeber_${hemi}_$labelName"]
                        #labl_set_info $labelN $l $x 1
                        
                        #labl_set_color label red green blue
                        #labl_set_color $labelN 255 0 0
                        labl_set_color $labelN $pmap($labelName,$r) $pmap($labelName,$g) $pmap($labelName,$b)
                        
                        set labelN [expr $labelN + 1]
                    }
                }

                select_vertex_by_vno 1
                clear_all_vertex_marks
                clear_vertex_marks

                restore_initial_position
                redraw

                UpdateAndRedraw
                
                
                # -----------------------------------------------
                # save graphics of the labels

                set subjTiffPrefix ${subject}_${hemi}_${ext}_labelstats_${effect}${timeWindow}ms
                set outputTiffPrefix [ file join ${subjTiffPath} ${subjTiffPrefix} ]

                snapshots $subjTiffPrefix $outputTiffPrefix
            }
        }
    }
}



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
    
    
    labl_remove_all
    restore_initial_position
    redraw
    
    UpdateAndRedraw
    
}
