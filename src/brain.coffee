# Description:
#   File brain for hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FILEBRAIN_PATH
#
# Commands:
#   hubot brain-util dump - dump the current hubot brain
#   hubot brain-util merge - merge the brain with a given json string
#
# Author:
#   Jack Ellenberger <jellenberger@uchicago.edu>
#   lightly modified from work by Josh King <jking@chambana.net>
#   lightly modified from work by dustyburwell

fs   = require 'fs'
path = require 'path'
util = require 'util'
deepMerge = require './deepmerge'

brainPath = process.env.HUBOT_FILEBRAIN_PATH || process.cwd()
date = new Date()
diskBrain = path.join(brainPath, "brain.json")
tmpBrain = path.join(brainPath, "brain-" + date.toISOString().substr(0, 10) + ".json")

module.exports = (robot) ->
  # Startup
  permData = readData(diskBrain)
  if !permData
    readData tmpBrain

  # On save
  robot.brain.on "save", (data) ->
    doSave robot, data

  # Utilities
  robot.respond /brain\-util dump/, (context) ->
    context.send (JSON.stringify robot.brain.data, null, 4)

  robot.respond /brain\-util merge (.*)/, (context) ->
    if (input = context.match[1])
      try
        json = JSON.parse input
        doSave robot, json
        context.send "Brain updated."
      catch err
        console.log err
        context.send "Can't parse that json, sorry!"

doSave = (robot, inMemoryData) ->
  if !(diskData = (readData diskBrain))
    tmpData = readData tmpBrain

  dataToSave = deepMerge (if diskData then diskData else tmpData), robot.brain.data, inMemoryData
  fs.writeFileSync (if diskData then diskBrain else tmpBrain), (JSON.stringify dataToSave, null, 4), 'utf-8'

readData = (file) ->
  data = null

  try
    data = fs.readFileSync(file, 'utf-8')
    data = JSON.parse data
  catch err
    if err.code != "ENOENT"
      console.log err

  return data

