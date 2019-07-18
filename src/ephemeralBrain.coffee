# Description:
#   An ephemeral in-memory brain for hubot for those values you don't want in the brain
# Dependencies:
#   None
#
# Commands
#   hubot ephemeral-brain-util set <expiration in seconds> ttl <key> <value>
#   

nodeCache = require 'node-cache'
ephemeralBrain = new nodeCache
defaultTTL = 30

module.exports = (robot) ->
  robot.respond /ephemeral-brain-util dump/i, (context) ->
    context.send ephemeralBrain.keys()

  robot.respond /ephemeral-brain-util set (?:(.*) ttl )?(.*) (.*)/i, (context) ->
    console.log context.match
    if (ttl = context.match[1] || defaultTTL) && (key = context.match[2]) && (val = context.match[3])
      console.log ttl, key, val
      isSet = ephemeralBrain.set key, val, ttl
      if isSet
        context.send "Set " + key + " for " + ttl + "s"
      else
        context.send "Ope, something went wrong just there"

  robot.respond /ephemeral-brain-util get (.*)/i, (context) ->
    if val = ephemeralBrain.get context.match[1]
      context.send val
    else
      context.send "Looks like that key isn't defined"

  robot.respond /ephemeral-brain-util (?:delete|expire|rm) (.*)/i, (context) ->
    val = ephemeralBrain.del context.match[1]
    context.send "k"
