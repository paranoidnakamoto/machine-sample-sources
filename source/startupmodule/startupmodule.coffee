startupmodule = {name: "startupmodule", uimodule: false}

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["startupmodule"]?  then console.log "[startupmodule]: " + arg
    return
print = console.log
installProcess = null

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
startupmodule.initialize = () ->
    log "startupmodule.initialize"
    installProcess = allModules.installprocessmodule

#region exposed functions
startupmodule.appStartup = ->
    log "startupmodule.appStartup"
    try
        update = process.argv[2]
        done = await installProcess.execute(update)
        if done then print('All done!\n');
    catch err
        print('Error!');
        print(err)
        print("\n")

#endregion exposed functions

export default startupmodule