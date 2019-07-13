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

brainPath = process.env.HUBOT_FILEBRAIN_PATH || process.cwd()
date = new Date()
diskBrain = path.join(brainPath, "brain.json")
tmpBrain = path.join(brainPath, "brain-" + date.toISOString().substr(0, 10) + ".json")

module.exports = (robot) ->
  # Startup
  permData = readAndMerge(robot, diskBrain)
  if !permData
    readAndMerge(robot, tmpBrain)

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
        robot.brain.mergeData json
        context.send "Brain updated."
      catch
        context.send "Can't parse that json, sorry!"

doSave = (robot, inMemoryData) ->
  if !(diskData = (readAndMerge robot, diskBrain))
    readAndMerge(robot, tmpBrain)

  brainData = JSON.stringify robot.brain.data, null, 4
  fs.writeFileSync (if diskData then diskBrain else tmpBrain), brainData, 'utf-8'

readAndMerge = (robot, file) ->
  data = null

  try
    data = fs.readFileSync(file, 'utf-8')
    data = JSON.parse data
    if data
      robot.brain.mergeData data
  catch err
    if err.code != "ENOENT"
      console.log err

  return data

