utilmodule = {name: "utilmodule", uimodule: false}

#region node_modules
spawn  = require('child_process').spawn
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["utilmodule"]? then console.log "[utilmodule]: " + arg
    return

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
utilmodule.initialize = () ->
    log "utilmodule.initialize"

#region exposed functions
utilmodule.executeCP = (file, dest) ->
    log "utilmodule.executeCP"
    spawnedScript = spawn("cp", [file, dest])
    return new Promise (resolve, reject) ->
        spawnedScript.stdout.on("data", ((data) -> log data))
        spawnedScript.stderr.on("data", ((data) -> log "error: " + data))
        spawnedScript.on("close", ((code) -> if (code == 0) then resolve(code) else reject(code)))    

utilmodule.executeRM = (file) ->
    log "utilmodule.executeRM"
    spawnedScript = spawn("rm", [file])
    return new Promise (resolve, reject) ->
        spawnedScript.stdout.on("data", ((data) -> log data))
        spawnedScript.stderr.on("data", ((data) -> log "error: " + data))
        spawnedScript.on("close", ((code) -> if (code == 0) then resolve(code) else reject(code))) 

utilmodule.executePwd = () ->
    log "utilmodule.executePwd"
    spawnedScript = spawn("pwd", [])
    return new Promise (resolve, reject) ->
        spawnedScript.stdout.on("data", ((data) -> log data))
        spawnedScript.stderr.on("data", ((data) -> log "error: " + data))
        spawnedScript.on("close", ((code) -> if (code == 0) then resolve(code) else reject(code)))

utilmodule.executeNginxReload = () ->
    log "utilmodule.executeNginxReload"
    spawnedScript = spawn("nginx", ["-s", "reload"])
    return new Promise (resolve, reject) ->
        spawnedScript.stdout.on("data", ((data) -> log data))
        spawnedScript.stderr.on("data", ((data) -> log "error: " + data))
        spawnedScript.on("close", ((code) -> if (code == 0) then resolve(code) else reject(code)))

utilmodule.executeSystemDaemonReload = () ->
    log "utilmodule.executeSystemDaemonReload"
    spawnedScript = spawn("systemctl", ["daemon-reload"])
    return new Promise (resolve, reject) ->
        spawnedScript.stdout.on("data", ((data) -> log data))
        spawnedScript.stderr.on("data", ((data) -> log "error: " + data))
        spawnedScript.on("close", ((code) -> if (code == 0) then resolve(code) else reject(code)))

utilmodule.executePerl = () ->
    log "utilmodule.executePerl"
    argumentList = (argument for argument in arguments)
    spawnedScript = spawn("perl", argumentList)

    return new Promise (resolve, reject) ->
        errorResponse = ""
        response = ""

        stdoutCallback = (data) ->
            log "stdout: " + data
            response += data
        stderrCallback = (data) ->
            log "stderr: " + data
            errorResponse += data
        exitCallback = (code) ->
            if (code == 0) then resolve(response) 
            else
                errorResponse += "Exit code: " + code + "\n"
                reject(errorResponse)

        spawnedScript.stdout.on("data", stdoutCallback)
        spawnedScript.stderr.on("data", stderrCallback)
        spawnedScript.on("close", exitCallback)

#endregion exposed functions

export default utilmodule



