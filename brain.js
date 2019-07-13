// Description:
//   File brain for hubot
//
// Dependencies:
//   None
//
// Configuration:
//   HUBOT_FILEBRAIN_PATH
//
// Commands:
//   None
//
// Author:
//   Jack Ellenberger <jellenberger@uchicago.edu>
//   lightly modified from work by Josh King <jking@chambana.net>
//   lightly modified from work by dustyburwell

const fs   = require('fs');
const path = require('path');
const _    = require('lodash');

const brainPath = process.env.HUBOT_FILEBRAIN_PATH || process.cwd();
const date = new Date();
const diskBrain = path.join(brainPath, "brain.json");
const tmpBrain = path.join(brainPath, "brain-"
  + date.toISOString().substr(0, 10)
  + ".json");

function doSave(robot, inMemoryData) {
  if (!(diskData = readAndMerge(robot, diskBrain))) {
    readAndMerge(robot, tmpBrain)
  }

  fs.writeFileSync(diskData ? diskBrain : tmpBrain, JSON.stringify(robot.brain.data, null, 4), 'utf-8');
}

function readAndMerge(robot, file) {
  var data;

  try {
    data = fs.readFileSync(file, 'utf-8');
    if (data) {
      robot.brain.mergeData(JSON.parse(data));
    }
  } catch { console.log(err) }

  return data;
}

module.exports = function(robot) {
  var permData = readAndMerge(robot, diskBrain)
  if (!permData) {
    readAndMerge(robot, tmpBrain)
  }

  return robot.brain.on("save", (data) => {
    doSave(robot, data);
  });
};

