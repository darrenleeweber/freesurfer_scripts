#! /bin/csh

#FREESURFER_HOME=/usr/local/freesurfer/
#FREESURFER_HOME=/netopt/freesurfer/
#SUBJECTS_DIR=/data/acetylcholine2/freesurfer/subjects

cd $SUBJECTS_DIR

#set srcsubject=ucsf_waOld
set srcsubject=ucsf_wa

foreach hemi ( 'lh' 'rh' )
    
    foreach labelFile (`ls ${srcsubject}/label/DLWeber_${hemi}*.label`)
        
        set label=`basename $labelFile`
        set vollabel=`echo $label | sed s/DLWeber_/DLWeber_volume_/`
        set surflabel=`echo $label | sed s/DLWeber_/DLWeber_surface_/`
        echo $label $vollabel $surflabel
        
        cp $labelFile ucsf_semicortex/${srcsubject}.$label
        
        # --------------------------------------

        foreach trgsubject (`ls -d ucsf_??`)
            
            #if ( "${trgsubject}" != "${srcsubject}" ) then
                echo ${trgsubject};

                # Run the Talairach volume based mapping
                mri_label2label \
                    --srclabel $SUBJECTS_DIR/${srcsubject}/label/$label    --srcsubject ${srcsubject} \
                    --trglabel $SUBJECTS_DIR/${trgsubject}/label/$vollabel --trgsubject ${trgsubject} \
                    --regmethod volume #--trgsurf pial
                
                set subLabelFile=`echo ${trgsubject}.$vollabel`
                cp $SUBJECTS_DIR/${trgsubject}/label/$vollabel ucsf_semicortex/$subLabelFile;

                # Run the surface based mapping
                mri_label2label \
                    --srclabel $SUBJECTS_DIR/${srcsubject}/label/$label     --srcsubject ${srcsubject} \
                    --trglabel $SUBJECTS_DIR/${trgsubject}/label/$surflabel --trgsubject ${trgsubject} \
                    --regmethod surface --hemi $hemi #--trgsurf pial
                
                set subLabelFile=`echo ${trgsubject}.$surflabel`
                cp $SUBJECTS_DIR/${trgsubject}/label/$surflabel ucsf_semicortex/$subLabelFile;

            #endif
        end
    end
end

exit


#USAGE: mri_label2label 
#
#   --srclabel   input label file 
#   --srcsubject source subject
#   --trgsubject target subject
#   --trglabel   output label file 
#   --regmethod  registration method (surface, volume) 
#
#   --hemi        hemisphere (lh or rh) (with surface)
#   --srchemi     hemisphere (lh or rh) (with surface)
#   --trghemi     hemisphere (lh or rh) (with surface)
#   --srcicoorder when srcsubject=ico
#   --trgicoorder when trgsubject=ico
#   --trgsurf     get xyz from this surface (white)
#   --surfreg     surface registration (sphere.reg)  
#   --srcsurfreg  source surface registration (sphere.reg)
#   --trgsurfreg  target surface registration (sphere.reg)
#
#   --srcmask     surfvalfile thresh <format>
#   --srcmasksign sign (<abs>,pos,neg)
#   --srcmaskframe 0-based frame number <0>
#
#   --projabs  dist project dist mm along surf normal
#   --projfrac frac project frac of thickness along surf normal
#
#   --sd subjectsdir : default is to use env SUBJECTS_DIR
#   --nohash : don't use hash table when regmethod is surface
#   --norevmap : don't use reverse mapping regmethod is surface
#
#  Purpose: Converts a label in one subject's space to a label
#  in another subject's space using either talairach or spherical
#  as an intermediate registration space. 
#
#  If a source mask is used, then the input label must have been
#  created from a surface (ie, the vertex numbers are valid). The 
#  format can be anything supported by mri_convert or curv or paint.
#  Vertices in the source label that do not meet threshold in the
#  mask will be removed from the label. See Example 2.
#
#  Example 1: If you have a label from subject fred called
#    broca-fred.label defined on fred's left hemispherical 
#    surface and you want to convert it to sally's surface, then
#
#    mri_label2label --srclabel broca-fred.label  --srcsubject fred 
#                    --trglabel broca-sally.label --trgsubject sally
#                    --regmethod surface --hemi lh
#
#    This will map from fred to sally using sphere.reg. The registration
#    surface can be changed with --surfreg.
#
#  Example 2: Same as Example 1 but with a mask
#
#    mri_label2label --srclabel broca-fred.label  --srcsubject fred 
#                    --trglabel broca-sally.label --trgsubject sally
#                    --regmethod surface --hemi lh
#                    --srcmask  fred-omnibus-sig 2 bfloat
#
#    This will load the bfloat data from fred-omnibus-sig and create
#    a mask by thresholding the first frame absolute values at 2.
#    To change it to only the positive values of the 3rd frame, add
#         --srcmasksign pos --srcmaskframe 2   
#
#
#  Example 3: You could also do the same mapping using talairach 
#    space as an intermediate:
#
#    mri_label2label --srclabel broca-fred.label  --srcsubject fred 
#                    --trglabel broca-sally.label --trgsubject sally
#                    --regmethod volume
#
#    Note that no hemisphere is specified with --regmethod volume.
#
#  Notes:
#
#  1. A label can be converted to/from talairach space by specifying
#     the target/source subject as 'talairach'.
#  2. A label can be converted to/from the icosahedron by specifying
#     the target/source subject as 'ico'. When the source or target
#     subject is specified as 'ico', then the order of the icosahedron
#     must be specified with --srcicoorder/--trgicoorder.
#  3. When the surface registration method is used, the xyz coordinates
#     in the target label file are derived from the xyz coordinates
#     from the target subject's white surface. This can be changed
#     using the --trgsurf option.
#  4. When the volume registration method is used, the xyz coordinates
#     in the target label file are computed as xyzTrg = inv(Ttrg)*Tsrc*xyzSrc
#     where Tsrc is the talairach transform in 
#     srcsubject/mri/transforms/talairach.xfm, and where Ttrg is the talairach 
#     transform in trgsubject/mri/transforms/talairach.xfm.
#  5. The registration surfaces are rescaled to a radius of 100 (including 
#     the ico)
#  6. Projections along the surface normal can be either negative or
#     positive, but can only be used with surface registration method.
#
#BUGS:
#
#When using volume registration method, you cannot specify the SUBJECTS_DIR
#on the command-line.
#
