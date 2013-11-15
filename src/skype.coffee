Readline = require 'readline'

#{Adapter,Robot,TextMessage,EnterMessage,LeaveMessage} = require 'hubot'
Robot                                   = require '../../../src/robot'
Adapter                                 = require '../../../src/adapter'
{TextMessage,EnterMessage,LeaveMessage} = require '../../../src/message'

class SkypekitAdapter extends Adapter
  send: (user, strings...) ->
    #out = ""
    #out = ("#{str}\n" for str in strings)
    #json = JSON.stringify
    #    room: user.room
    #    message: out.join('')
    #console.log "JSON out:" + json
    #@skype.stdin.write json + '\n'
    #@skype.stdin.flush()
    for str in strings
      if not str?
        continue
      if user.room
        console.log "#{user.name} #{user.room} #{str}"
        json = JSON.stringify
          room: user.room
          message: str
        console.log json
        @skype.stdin.write json
      else
        console.log "#{user} #{str}"

  reply: (user, strings...) ->
    @send user, strings...

  createUser: (room, from) ->
      user = @userForName from
      unless user?
        id = (new Date().getTime() / 1000).toString().replace('.','')
        user = @userForId id
        user.name = from

      user.room = room
      user

  run: ->
    self = @
    stdin = process.openStdin()
    stdout = process.stdout

    @skype = require('child_process').spawn(__dirname + '/skype.py')
    @skype.stdout.on 'data', (data) =>
        #console.log "JSON in: " + data.toString()
        decoded = JSON.parse(data.toString())
        #user = @userForId decoded.user, name: decoded.user, room: decoded.room
        user = self.createUser decoded.room, decoded.user
        #user.room = decoded.room
        return unless decoded.message
        #console.log decoded.message
        @send user, "Received: #{decoded.message}"
        @receive new TextMessage(user, decoded.message)
    @skype.stderr.on 'data', (data) =>
        console.log "skype.py error: "
        console.log data.toString()
    @skype.on 'exit', (code) =>
        console.log('child process exited with code ' + code)
    @skype.on "uncaughtException", (err) =>
      @robot.logger.error "Uncaught Exception (Skype): #{err}"

    process.on "uncaughtException", (err) =>
      @robot.logger.error "Uncaught Exception (process): #{err}"

    process.on "exit", () =>
      console.log "Shutting down child process"
      @skype.kill()

    @robot.name = "ushbot"

    console.log "Connected"

exports.use = (robot) ->
  new SkypekitAdapter robot
