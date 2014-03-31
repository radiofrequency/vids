(->
  throw new Error("settings-development.js must be loaded as a module.")  if typeof exports is "undefined"
  logger = require("logging")

  settings =
    env: "development"
    redis_host: "127.0.0.1"
    redis_port: 6379
    node_port: 9228
    node_host: "localhost:9229"
    node_scheme: "http://"
    num_node_process: 1
    appname: "videoz"
    appheadline: "share videos from your phone"
    max_upload_mb: 1000

  module.exports = settings
  return

)()