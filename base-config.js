
var config = {};


var webhookPort = 5555

// identifying name
config.name = "sample-machine"

// webhook relevant config
config.ipAddress = "111.111.111.111" // IPv4 Address of the machine
config.uri = "/webhook"
config.webhookSecret = "sluttysecret" //useless secret because we use http^^
config.webhookPort = webhookPort

//most basic thingies
config.thingies = [
    {
        homeUser: "root",
        repository: "sample-machine-output",
        branch: "release",
        newProp: false,
        type:"installer",
        updateCode: [
            "cd /root/sample-machine-output; git pull origin release; node installer.js update;"
        ]
    }
    ,
    {
        homeUser: "webhook-handler",
        repository: "webhook-handler-deploy",
        branch: "release",
        type:"service",
        socket: true,
        oneshot: true,
        outsidePort: webhookPort,
        updateCode: [
            "sudo -u webhook-handler -H sh -c 'cd /home/webhook-handler/webhook-handler-deploy; git pull origin release'"
        ]
    }
]

module.exports = config;
