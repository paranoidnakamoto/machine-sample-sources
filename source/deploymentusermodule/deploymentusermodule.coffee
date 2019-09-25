deploymentusermodule = {name: "deploymentusermodule", uimodule: false}


#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["deploymentusermodule"]?  then console.log "[deploymentusermodule]: " + arg
    return

utl = null
githubRemote = null
hasher = null

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
deploymentusermodule.initialize = () ->
    log "deploymentusermodule.initialize"
    utl = allModules.utilmodule
    hasher = allModules.hashermodule
    githubRemote = allModules.githubremotemodule

#region exposed functions
## digestion functions - - - - - - - - - -- - 
deploymentusermodule.generateContainerFilesDigest = (thingy) ->
    log "deploymentusermodule.generateContainerFileDigest"
    allFiles = {}
    return await hasher.hashAllFiles(allFiles)

deploymentusermodule.generateServiceFilesDigest = (thingy) ->
    log "deploymentusermodule.generateServiceFileDigest"
    allFiles = 
        nginxConfig:
            path: "nginx-files/" + thingy.homeUser
        privateKey:
            path:  "keys/" + thingy.repository
        serviceFile:
            path: "service-files/" + thingy.homeUser + ".service"
    
    if thingy.socket
        allFiles.socketFile = 
            path: "service-files/" + thingy.homeUser + ".socket"
    
    return await hasher.hashAllFiles(allFiles)

deploymentusermodule.generateWebsiteFilesDigest = (thingy) ->
    log "deploymentusermodule.generateDigestForCopiedFiles"
    allFiles = 
        nginxConfig:
            path: "nginx-files/" + thingy.homeUser
        privateKey:
            path:  "keys/" + thingy.repository
    return await hasher.hashAllFiles(allFiles)

## install functions
deploymentusermodule.setUpUser = (thingy) ->
    log "deploymentusermodule.setUpUser"
    script = "scripts/create-deployment-user.pl"
    username = thingy.homeUser
    reponame = thingy.repository 
    branch = thingy.branch
    remoteObject = githubRemote.createRemote("JhonnyJason", reponame)
    remoteurl = remoteObject.getSSH()

    result = await utl.executePerl(script, username, reponame, remoteurl, branch)

deploymentusermodule.createSymlinkForNginx = (thingy) ->
    log "deploymentusermodule.setUpUser"
    script = "scripts/create-symlink-for-nginx.pl"
    username = thingy.homeUser
    reponame = thingy.repository 

    result = await utl.executePerl(script, username, reponame)

deploymentusermodule.copyNginxConfig = (thingy) ->
    log "deploymentusermodule.copyNginxConfig"
    script = "scripts/copy-server-config.pl"
    username = thingy.homeUser
    return await utl.executePerl(script, username)

deploymentusermodule.setUpSystemd = (thingy) ->
    log "deploymentusermodule.setUpSystemd"
    script = "scripts/copy-and-run-service.pl"
    username = thingy.homeUser    
    
    if thingy.socket then result = await utl.executePerl(script, username, thingy.socket)
    else result = await utl.executePerl(script, username)
    return result

deploymentusermodule.setUpDocker = (thingy) ->
    log "deploymentusermodule.setUpDocker"
    throw new Error("Not Implemented yet!")
    script = "scripts/build-and-run-container.pl"
    username = thingy.homeUser    
    
    return await utl.executePerl(script, username)

deploymentusermodule.copyKeys = (thingy) ->
    log "deploymentusermodule.copyKeys"
    script = "scripts/copy-keys.pl"
    username = thingy.homeUser
    reponame = thingy.repository

    result = await utl.executePerl(script, username, reponame)


## remove functions
deploymentusermodule.removeUser = (thingy) ->
    log "deploymentusermodule.removeUser"
    script = "scripts/remove-deployment-user.pl"
    username = thingy.homeUser        
    return await utl.executePerl(script, username)
    
deploymentusermodule.stopRemoveService = (thingy) ->
    log "deploymentusermodule.stopRemoveService"
    script = "scripts/stop-and-remove-service.pl"
    username = thingy.homeUser    
    
    if thingy.socket then result = await utl.executePerl(script, username, thingy.socket)
    else result = await utl.executePerl(script, username)
    return result

#endregion exposed functions

export default deploymentusermodule