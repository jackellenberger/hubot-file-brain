# hubot-file-brain-utils
A hubot file brain with support for cold and warm starts, as well as a few helpful commands.

## Install
In your hubot instance, run the following:
```
npm install --save @jackellenberger/hubot-file-brain-utils
```
and then add `@jackellenberger/hubot-file-brain-utils` to `external-scripts.json`.

## Usage
When starting Hubot, provide a directory path via the environment variable `HUBOT_FILEBRAIN_PATH`. This script will save Hubot state into a `brain.json` file in the directory provided.
