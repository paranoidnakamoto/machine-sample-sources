configmodule = {name: "configmodule", uimodule: false}

#region node_modules
fs = require("fs")
#endregion

machineConfig  = require("../../../sources/machine-config")

digestPath = "install-digest.json"

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["configmodule"]?  then console.log "[configmodule]: " + arg
    return

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
configmodule.initialize = () ->
    log "configmodule.initialize"
    try readInstallDigest()
    catch err
        log "could not read install Digest!"
        log err
    return

#region internal function
readInstallDigest = ->
    log "readInstallDigest"
    digestString = String(fs.readFileSync(digestPath))
    configmodule.installDigest = JSON.parse(digestString)
#endregion

#region exposed variables
configmodule.thingies = machineConfig.thingies
configmodule.installDigest = {}
#endregion

#region exposed functions
configmodule.writeInstallDigest = ->
    log "configmodule.writeInstallDigest"
    # console.log JSON.stringify(configmodule.installDigest, null, 2)
    digestString = JSON.stringify(configmodule.installDigest, null, 2)
    fs.writeFileSync(digestPath, digestString)

#endregion

export default configmodule
