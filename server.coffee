defaultsettings = "/settings-dev.js"
defaultsettings = "/settings-" + process.argv[2]  if process.argv[2]?
settings = require(__dirname + defaultsettings)
process.on "error", (err) ->
  console.log "error", err

cluster = require("cluster")
os = require("os")
setupMaster = ->
  if settings.env is "development"
    cluster.fork()
  else
    i = 0

    while i < settings.num_node_process
      cluster.fork()
      i++
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"


generateId = (linkset, callback) ->
  id = ""
  chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  keyLength =1
  rc.scard linkset, (error, response) ->
    keyLength++  while Math.pow(chars.length, keyLength) / 2 < response
    i = 0

    while i < keyLength
      id += chars[Math.floor(Math.random() * chars.length)]
      i++
    callback id
    return
  return

shorten = (linkset, long, callback) ->
  unless long?
    response =
      status: "ERROR"
      message: "Invalid URL: " + long
    callback response  if typeof (callback) is "function"
    return false
  generateId linkset, (newId) ->
    rc.setnx linkset + ":" + newId, long, (err, res) ->
      if res
        response =
          status: "OK"
          id: newId
          long: long

        rc.sadd linkset, newId, ->
          return callback(response)

      else
        shorten linkset, long, callback

    return
  return
  return





setupMaster()  if cluster.isMaster
if cluster.isWorker
  express = require("express")
  jade = require("jade")
  app = express()
  http = require("http")
  server = http.createServer(app)
  redis = require("redis")
  path = require("path")
  connect = require("connect")
  rc = redis.createClient(settings.redis_port, settings.redis_host)
  fs = require("fs")
  _ = require("underscore")

  mime = require("simple-mime")("text/plain")

  app.configure ->
    app.set "view engine", "jade"
    app.set "view options",
      layout: false


    app.set "views", __dirname + "/views"

    app.use express.json()
    app.use(express.limit(1048576 * settings.max_upload_mb));
    app.use express.bodyParser({uploadDir: __dirname + '/static/uploads', keepExtensions:true});
    app.use express.favicon(__dirname + "/static/icons/favicon.ico")
    app.use "/static", express.static(__dirname + "/static")

    app.get '/', (req, res) ->
      res.render('index', null);
      return

    app.get '/video/:id', (req,res) ->
      id = req.param("id")
      fileHashKey = "hfile:" + "video" + ":" + id
      rc.hmget fileHashKey, "filename", (err, filename) ->
        res.render('video', {id: req.param("id"), vid:filename.toString(), share_subject:"check out this video on vids.d8.io", share_link:"https://vids.d8.io/video/" + id})
        return
      return

    app.post '/submit', (req,res) ->
        console.log(req.files.path)
        local_filename = req.files.uploadfile.path
        filename = path.basename(local_filename)
       # extension = path.extname(local_filename)


        type = "video"
        shorten "video", "placeholder", (data)->
          videoid = data.id
          fileHashKey = "hfile:" + type + ":" + videoid

          rc.zadd "zfile:" + type, Math.round((new Date()).getTime() / 1000), videoid, (err, data) ->
              fn new Error("write zfile", "uploadFile")  if err
              rc.hmset fileHashKey, { local_filename: local_filename, filename: filename, id: videoid, type: type }, (err, hmsetdata) ->
                # return fn(new Error("write hmset", "uploadFile"))  if err
                res.redirect("video/" +  videoid )
              return
          return
        return

  server.listen settings.node_port + cluster.worker.id






