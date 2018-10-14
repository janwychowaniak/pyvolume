#!/bin/bash



########################################################################
                                                                      ##
CONFIG="config.sh"                                                    ##
                                                                      ##
DANE_XBT_TURNOVER24H="data/data_XBT_turnover24h"                      ##
DANE_XBT_VOLUME24H="data/data_XBT_volume24h"                          ##
DANE_XBT_OPENINTEREST="data/data_XBT_openInterest"                    ##
DANE_XBT_OPENVALUE="data/data_XBT_openValue"                          ##
                                                                      ##
MEDIANA_XBT_TURNOVER24H="data/data_XBT_turnover24h_mediana"           ##
MEDIANA_XBT_VOLUME24H="data/data_XBT_volume24h_mediana"               ##
MEDIANA_XBT_OPENINTEREST="data/data_XBT_openInterest_mediana"         ##
MEDIANA_XBT_OPENVALUE="data/data_XBT_openValue_mediana"               ##
                                                                      ##
PLOT_XBT_TURNOVER24H="plots/plot_XBT_turnover24h.png"                 ##
PLOT_XBT_VOLUME24H="plots/plot_XBT_volume24h.png"                     ##
PLOT_XBT_OPENINTEREST="plots/plot_XBT_openInterest.png"               ##
PLOT_XBT_OPENVALUE="plots/plot_XBT_openValue.png"                     ##
                                                                      ##
DATAREAD_SCRIPT="volume_turnover_py.py"                               ##
PLOT_SCRIPT="plot_data.sh"                                            ##
TRUNCATE_1ST_LINE="trun_1st_line.sh"                                  ##
CALCULATE_MEDIAN="median.py"                                          ##
                                                                      ##
########################################################################


# check inputs
inputs_exist=true
[[ ! -f $DANE_XBT_TURNOVER24H  ]] && echo " *** $DANE_XBT_TURNOVER24H nie istnieje"  && inputs_exist=false
[[ ! -f $DANE_XBT_VOLUME24H    ]] && echo " *** $DANE_XBT_VOLUME24H nie istnieje"    && inputs_exist=false
[[ ! -f $DANE_XBT_OPENINTEREST ]] && echo " *** $DANE_XBT_OPENINTEREST nie istnieje" && inputs_exist=false
[[ ! -f $DANE_XBT_OPENVALUE    ]] && echo " *** $DANE_XBT_OPENVALUE nie istnieje"    && inputs_exist=false
[[ ! -f $MEDIANA_XBT_TURNOVER24H  ]] && echo " *** $MEDIANA_XBT_TURNOVER24H nie istnieje"  && inputs_exist=false
[[ ! -f $MEDIANA_XBT_VOLUME24H    ]] && echo " *** $MEDIANA_XBT_VOLUME24H nie istnieje"    && inputs_exist=false
[[ ! -f $MEDIANA_XBT_OPENINTEREST ]] && echo " *** $MEDIANA_XBT_OPENINTEREST nie istnieje" && inputs_exist=false
[[ ! -f $MEDIANA_XBT_OPENVALUE    ]] && echo " *** $MEDIANA_XBT_OPENVALUE nie istnieje"    && inputs_exist=false

# check tools
tools_exist=true
[[ ! -f $DATAREAD_SCRIPT   ]] && echo " *** $DATAREAD_SCRIPT nie istnieje"        && tools_exist=false
[[ ! -f $PLOT_SCRIPT       ]] && echo " *** $PLOT_SCRIPT nie istnieje"            && tools_exist=false
[[ ! -f $TRUNCATE_1ST_LINE ]] && echo " *** $TRUNCATE_1ST_LINE nie istnieje"      && tools_exist=false
[[ ! -f $CALCULATE_MEDIAN  ]] && echo " *** $CALCULATE_MEDIAN nie istnieje"       && tools_exist=false

# check config
config_exist=true
[[ ! -f $CONFIG  ]] && echo " *** $CONFIG nie istnieje"  && config_exist=false

# evaluate checks
[[ ! "$inputs_exist"  == true ]] && exit 1
[[ ! "$tools_exist"   == true ]] && exit 1
[[ ! "$config_exist"  == true ]] && exit 1


# do config
source $CONFIG
PYTHON=`which python3`


echo "-------------------------------------------------------------------------------"

# print diag
echo    "    python3:      $PYTHON"
echo -n "    parent shell: " ; grep '^Name' /proc/`grep '^PPid' /proc/$$/status |cut -f2`/status |cut -f2
echo -n "    interpreter:  " ; ps h -p $$ -o args='' | cut -f1 -d' '


echo " -----------"

# truncate 1st line
if [ "$ROLLING_ENABLED" == "yes" ] ; then
  echo "rolling enabled"
  ./$TRUNCATE_1ST_LINE $DANE_XBT_TURNOVER24H
  ./$TRUNCATE_1ST_LINE $DANE_XBT_VOLUME24H
  ./$TRUNCATE_1ST_LINE $DANE_XBT_OPENINTEREST
  ./$TRUNCATE_1ST_LINE $DANE_XBT_OPENVALUE
  ./$TRUNCATE_1ST_LINE $MEDIANA_XBT_TURNOVER24H
  ./$TRUNCATE_1ST_LINE $MEDIANA_XBT_VOLUME24H
  ./$TRUNCATE_1ST_LINE $MEDIANA_XBT_OPENINTEREST
  ./$TRUNCATE_1ST_LINE $MEDIANA_XBT_OPENVALUE
else
  echo "no rolling"
fi

echo " -----------"

# read from bitmex
$PYTHON  $DATAREAD_SCRIPT       $DANE_XBT_TURNOVER24H  $DANE_XBT_VOLUME24H  $DANE_XBT_OPENINTEREST  $DANE_XBT_OPENVALUE
# get medians
$PYTHON  $CALCULATE_MEDIAN  $DANE_XBT_TURNOVER24H  $MEDIANA_XBT_TURNOVER24H
$PYTHON  $CALCULATE_MEDIAN  $DANE_XBT_VOLUME24H    $MEDIANA_XBT_VOLUME24H
$PYTHON  $CALCULATE_MEDIAN  $DANE_XBT_OPENINTEREST $MEDIANA_XBT_OPENINTEREST
$PYTHON  $CALCULATE_MEDIAN  $DANE_XBT_OPENVALUE    $MEDIANA_XBT_OPENVALUE

echo " -----------"

# plot
./$PLOT_SCRIPT  $DANE_XBT_TURNOVER24H  $MEDIANA_XBT_TURNOVER24H  $PLOT_XBT_TURNOVER24H
./$PLOT_SCRIPT  $DANE_XBT_VOLUME24H    $MEDIANA_XBT_VOLUME24H    $PLOT_XBT_VOLUME24H
./$PLOT_SCRIPT  $DANE_XBT_OPENINTEREST $MEDIANA_XBT_OPENINTEREST $PLOT_XBT_OPENINTEREST
./$PLOT_SCRIPT  $DANE_XBT_OPENVALUE    $MEDIANA_XBT_OPENVALUE    $PLOT_XBT_OPENVALUE

echo " -----------"
