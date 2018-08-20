#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Tar and timestamp an archive
##
## @category Linux Scripts
## @package tarTime
## @version 20180820
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

# At least two arguments
if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: $(basename $0) <destination> <source1>"
    echo -e "\tCompress the source into a timestamped bz2 archive."
    echo -e "\t<destination>\tDestination archive."
    echo -e "\t<source>\tSource to compress"
    exit 1
fi

# Build and save the destination filename.
declare sDestination="${1}-$(uname -n)-$(date +"%Y%m%d")_$(date +"%H%M").tar.bz2"

# Remove the destination from the arguments
shift

# Save the sources
declare sSources="$@"

# Do the job
declare -i iReturn=0
echo "Tar and timestamp: ${sSources}"
echo "To: ${sDestination}"
tar cjf "${sDestination}" ${sSources}
iReturn=$?
if ((iReturn)); then
    echo "Compression failed: ${iReturn}"
else
    echo "Job is done!"
fi
exit ${iReturn}
