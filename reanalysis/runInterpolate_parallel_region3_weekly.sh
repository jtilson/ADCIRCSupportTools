#!/bin/sh
#SBATCH -t 512:00:00
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2 
#SBATCH -J Reanalysis
#SBATCH --mem-per-cpu 512000

#export YEAR=2018
export YEAR=2018DA
export YEARNUMBER=2018

export SILL=0.015
export RANGE=8
export NUGGET=0.005

WEEKLY=WEEKLY-2018YEAR-12MONTH-REGION3-RANGE$RANGE-SILL$SILL-NUGGET$NUGGET-LP48

export CODEBASE=/projects/sequence_analysis/vol1/prediction_work/ADCIRCSupportTools/ADCIRCSupportTools/reanalysis
export PYTHONPATH=/projects/sequence_analysis/vol1/prediction_work/ADCIRCSupportTools/ADCIRCSupportTools
export RUNTIMEDIR=.
export BASEDIREXTRA=REANALYSIS_COMPREHENSIVE_REGION3/YEARLY-$YEAR

# Build the yearly error file store in $RUNTIMEDIR/BASEDIREXTRA
#python $CODEBASE/yearlyReanalysis.py --iosubdir $BASEDIREXTRA --urljson region3.json --grid region3
#python $CODEBASE/yearlyReanalysis.py --iosubdir $BASEDIREXTRA --urljson region3_da.json --grid region3

# Store files in $RUNTIMEDIR/WEEKLY/errorfield
export INDIR=$RUNTIMEDIR/$BASEDIREXTRA
export OUTROOT=$RUNTIMEDIR/$BASEDIREXTRA/$WEEKLY
python $CODEBASE/weeklyLowpassSampledError.py --inyear $YEARNUMBER --inDir $INDIR --outroot $OUTROOT
mv $RUNTIMEDIR/AdcircSupportTools.log $OUTROOT/log-weekly

# Interpolate a single specific file
export ADCJSON=$INDIR/adc_coord.json
export CLAMPFILE=$CODEBASE/config/clamp_list_hsofs.dat
#export YAMLNAME=$CODEBASE/config/int.REANALYSIS.yml
export YAMLNAME=$CODEBASE/config/int.REANALYSIS.yml
export OUTROOT=$RUNTIMEDIR/$BASEDIREXTRA/$WEEKLY
export ERRDIR=$OUTROOT/errorfield
python  $CODEBASE/runInterpolate_parallel_weekly.py  --insill $SILL --inrange $RANGE --outroot $OUTROOT --yamlname $YAMLNAME --errordir $ERRDIR --clampfile $CLAMPFILE --gridjsonfile $ADCJSON
mv $RUNTIMEDIR/AdcircSupportTools.log $OUTROOT/log-interpolate
