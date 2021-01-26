
var config = {};

var webhookPort = 55555
var serverName = "servername.domain.tld"

// identifying name
config.name = "servername"

// webhook relevant config
config.serverName = serverName
config.uri = "/webhook"
config.webhookSecret = "sluttysecretofservername"
config.webhookPort = webhookPort

//most basic thingies
config.thingies = [
    {
        type:"installer",

        repository: "servername-output",
        branch: "release",

        homeUser: "root"
    },
    {
        type:"service",
        socket: true,
        oneshot: true,
        dnsNames: [ serverName ],
        outsidePort: webhookPort,

        repository: "webhook-handler-deploy",
        branch: "release",

        homeUser: "webhook-handler"
    }
]

module.exports = config;