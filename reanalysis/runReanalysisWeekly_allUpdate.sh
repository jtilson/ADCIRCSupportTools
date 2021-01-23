#!/bin/sh
#SBATCH -t 512:00:00
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2 
#SBATCH -J Reanalysis
#SBATCH --mem-per-cpu 512000

export CODEBASE=/projects/sequence_analysis/vol1/prediction_work/CausalInference/CausalNetworking_forKirk/TEST/ADCIRCSupportTools
export PYTHONPATH=$CODEBASE:$PYTHONPATH
export RUNTIMEDIR=.

# Build the yearly error file store in $RUNTIMEDIR
# python yearlyReanalysis.py --rootdir ./YEARLY--urljson reanalysis.json

# Store files in $RUNTIMEDIR/WEEKLY/errorfield
export INDIR=$RUNTIMEDIR/YEARLY
export OUTROOT=$RUNTIMEDIR/YEARLY/WEEKLY
#python weeklyLowpassSampledError.py --inyear 2018 --inDir $RUNTIMEDIR --outroot $OUTROOT

# Interpolate all stationAves files in the specified directory
export OUTROOT=$RUNTIMEDIR/YEARLY/WEEKLY
export ERRDIR=$OUTROOT/errorfield
export ADCJSON=$INDIR/adc_coord.json
export CLAMPFILE=$CODEBASE/config/clamp_list_hsofs.dat
export YAMLNAME=$CODEBASE/config/int.REANALYSIS.yml
export OUTROOT=./YEARLY/WEEKLY
python  iterateKriging.py  --outroot $OUTROOT --yamlname $YAMLNAME --errordir $ERRDIR --clampfile $CLAMPFILE --gridjsonfile $ADCJSON
