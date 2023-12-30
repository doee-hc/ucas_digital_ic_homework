#! /bin/sh
rm -fr ./template
dc_shell -f ./rundc.tcl | tee dc_link.log
