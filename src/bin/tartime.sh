#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Tar and timestamp an archive
##
## @package ojullien\Shell\bin
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

# At least two arguments
if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: $(basename "$0") <destination> <source1> [source2] ..."
    echo -e "\tCompress the source into a timestamped bz2 archive."
    echo -e "\t<destination>\tDestination archive."
    echo -e "\t<source>\tSource to compress"
    exit 1
fi

# Build and save the destination filename. The first argument is the destination file
readonly sDestination="${1}-$(uname -n)-$(date +"%Y%m%d")_$(date +"%H%M").tar.bz2"

# Remove the destination from the arguments
shift

# Save the sources
readonly sSources=$*

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
