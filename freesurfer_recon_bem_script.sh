#!/bin/bash

echo $0 $1

cd $SUBJECTS_DIR
pwd

if [ "$1" = "" ]; then
    echo
    echo "Missing <subjID>, please use"
    echo "$0 <subjID>"
    echo
    exit 1
fi


if [ -d $1 ]; then
    
    echo
    echo "...processing subject: $1"
    echo

    # has this been done already?
    if [ -s $1/surf/lh.pial && -s $1/surf/rh.pial ]; then
	echo
	echo "The pial surfaces already exist:"
	echo
	ls -l $1/surf/*
	echo
    else
	recon-all -subjid $1 -all
    fi


    # add extraction of the BEM surfaces
    if [ -s $1/bem/${1}_brain_surface ]; then
	echo
	echo "The BEM surfaces already exist:"
	echo
	ls -l $1/bem/*
	echo
    else
	pushd ${1}/mri
	mri_watershed -atlas \
	    -surf $SUBJECTS_DIR/${1}/bem/$1 \
	    T1.mgz brainmask.auto.mgz
	popd
    fi

fi
