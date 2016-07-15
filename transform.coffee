fs = require 'fs'

quotes = {}

for n in [1..45]
  string = fs.readFileSync("embed.js.#{n}").toString()

  string = string.split('\n').filter((x) -> x.match(/document\.write\(JSON\.parse\(/))

  json = string[0].replace(/^\s*document\.write\(JSON\.parse\((.*)\)\s*\)\s*$/, '$1')

  json = json.replace(/<[^<>]*>/g, '')

  json = json.split '\\\\n'

  currentSpeaker = null

  for line in json when line.trim() not in ['Lin-Manuel Miranda']
    if line.match(/^\s*\[.*\]\s*$/)
      currentSpeaker = line.replace(/^\s*\[(.*)\]\s*$/, '$1')
      quotes[currentSpeaker] ?= []
    else if line.indexOf('[') > -1 or line.indexOf(']') > -1
      currentSpeaker = null
    else if currentSpeaker? and line.match(/\w/)?
      quotes[currentSpeaker].push line

fs.writeFileSync 'quotes.json', JSON.stringify quotes
