#!/bin/bash

########################################################################
# 
# shmisorter.sh - A sorting script that uses smhicleaner.sh bare data
#
# Author: Artis Vijups
#
# Description: this script reorders the cleaned dataset generated by 
#              smhicleaner.sh from highest temperature to lowest.
#
# Examples:
#        ./smhisorter.sh smhi-opendata_1_52240_20200905_163726.csv
#
# NOTE: The CSV file is not necessarily available or in the same folder.
#
########################################################################

  #
 ## 
# #   PART 1
  #   The following code comes from modifying smhifilter.sh
#####

# Memorize script name
SORTER_SCRIPTNAME=`basename $0`

###### Functions #######################################################

## usage
# this function takes no parameters and prints an error with the 
# information on how to run this script.
usage(){
	echo "----"
	echo -e "  To call this script please use"
	echo -e "   $0 '<path-to-datafile>'"
	echo -e "  Example:"
    echo -e "   $0 'smhi-opendata_1_52240_20200905_163726.csv'"
	echo "----"
}

## log functions
# Create log file with date
# Usage: 
#   createlog
createlog(){
  SORTER_DATE=`date +%F`
  SORTER_LOGFILE=${SORTER_DATE}_${SORTER_SCRIPTNAME}.log
  touch $SORTER_LOGFILE
  if [[ $? != 0 ]]; then
     echo "cannot write logfile, exiting" 1>&2
     exit 1
  fi
  echo "Redirecting SORTER logs to $SORTER_LOGFILE"
}

# logging utility
# Adds a timestamp to a log message and writes to file created with createlog
# Usage:
#   log "message"
# If logfile missing use default CLEANER_LOGFILE
log(){
  if [[ "x$SORTER_LOGFILE" == "x" ]]; then
    echo "Undefined variable SORTER_LOGFILE, please check code: createlog() missing. Exiting" 1>&2
    exit 1
  fi
  SORTER_LOGMESSAGE=$1
  SORTER_LOGTIMESTAMP=`date -Iseconds`
  # Create timestamped message
  SORTER_OUTMESSAGE="[${SORTER_LOGTIMESTAMP} Sorter]: $SORTER_LOGMESSAGE"
  # Output to screen
  echo $SORTER_OUTMESSAGE
  # Output to file
  echo $SORTER_OUTMESSAGE >> ${SORTER_LOGFILE}
}

###### Functions END =##################################################

# Exit immediately if the smhicleaner.sh script is not found
if [ ! -f 'smhicleaner.sh' ]; then
   echo "shmicleaner.sh script not found in $PWD. Cannot continue. Exiting"
   exit 1
fi
 
# Create logfile
createlog

# Get the first parameter from the command line:
# and put it in the variable SORTER_SMHIINPUT
SORTER_SMHIINPUT=$1

# Input parameter validation:
# Check that the variable SORTER_SMHIINPUT is defined, if not, 
# inform the user, show the script usage by calling the usage() 
# function in the library above and exit with error
if [[ "x$SORTER_SMHIINPUT" == 'x' ]]; then
   echo "Missing input file parameter, exiting" 1>&2
   usage
   exit 1
fi

# Extract filename:
# Extract the name of the file using the "basename" command 
# then store it in a variable SORTER_DATAFILE
SORTER_DATAFILE=$(basename $SORTER_SMHIINPUT)

# Call smhicleaner
log "Calling smhicleaner.sh script"
./smhicleaner.sh $SORTER_SMHIINPUT

if [[ $? != 0 ]]; then
   echo "smhicleaner.sh failed, exiting..." 1>&2
   exit 1
fi

# smhicleaner.sh generates a filename baredata_<datafilename>,
# storing it in a variable for convenience.
CLEANER_BAREDATAFILENAME="baredata_$SORTER_DATAFILE"

####
    # 
 ###  PART 2
#     The following code is created specifically for smhisorter.sh
#####

# Specifying the delimiter - a mismatch here with smhicleaner.sh can cause wrong results
DELIMITER="~"
log "Beginning sorting procedure with delimiter '$DELIMITER'..."
log "(!) In case of unexpected final results, verify that '$DELIMITER' is the correct delimiter"

# Sorting lowest to highest
LOWESTFIRST_FILENAME="lowestfirst_$SORTER_DATAFILE"
log "Sorting from lowest temperature to highest, writing to $LOWESTFIRST_FILENAME"
sort -k3 -n -t$DELIMITER $CLEANER_BAREDATAFILENAME > $LOWESTFIRST_FILENAME

# Reversing order
HIGHESTFIRST_FILENAME="highestfirst_$SORTER_DATAFILE"
log "Reversing order to go from highest temperature to lowest, writing to $HIGHESTFIRST_FILENAME"
tac $LOWESTFIRST_FILENAME > $HIGHESTFIRST_FILENAME

# Exit code check
if [[ $? != 0 ]]; then
   echo "Sorting procedure failed, exiting..." 1>&2
   exit 1
fi
log "Sorting procedure complete"