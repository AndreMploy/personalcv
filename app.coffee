express = require 'express'
http = require 'http'
os = require 'os'    
path = require 'path'
stylus = require 'stylus'

# In the production environment, asset files are served by nginx and
# not node.
host = os.hostname()
basedir = if host == 'lindent' then '/var/www/personalcv' else __dirname
pubdir = path.join(basedir, 'public')    

app = express()
app.configure ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    if host != 'lindent'
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
