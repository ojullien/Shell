## -----------------------------------------------------------------------------
## Linux Scripts.
## UpdateSystem app functions
##
## @package ojullien\Shell\app\updatesystem
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Deborphan
## -----------------------------------------------------------------------------
UpdateSystem::findOrphan() {
    String::notice "Find orphan"
    deborphan
}

UpdateSystem::findOrphanConfig() {
    String::notice "Find orphan config"
    deborphan --find-config
}

UpdateSystem::purgeLocales() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice "Removing unneeded localizations..."
    localepurge
    iReturn=$?
    String::notice -n "Remove unneeded localizations:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

UpdateSystem::updateDB() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice -n "Updating database for mlocate..."
    updatedb
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
