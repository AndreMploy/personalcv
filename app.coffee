express = require 'express'
http = require 'http'
os = require 'os'    
path = require 'path'
stylus = require 'stylus'

app = express()
app.configure ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    # In the production environment, asset files are served by nginx
    # and not node.
    host = os.hostname()
    if host != 'lindent'
        pubdir = path.join(__dirname, 'public')
        app.use(stylus.middleware(pubdir))
        app.use(express.static(pubdir))

app.configure 'development', ->
    app.use(express.errorHandler())

app.get '/', (req, res) ->
    # Customize title here. A good idea is to stuff at least some
    # keywords in there to make GoogleBot happy.
    name = 'Björn Lindqvist'
    res.render 'index', {
        title: 'Hire ' + name + ', Consultant, Online Resume and Curriculumn Vitae'
    }

server = http.createServer(app)
server.listen 3000
