fs = require 'fs'

sequences = []

files = ("embed.js.#{n}" for n in [1..45]).concat(['embed.js'])

for file in files
  string = fs.readFileSync(file).toString()

  string = string.split('\n').filter((x) -> x.match(/document\.write\(JSON\.parse\(/))

  json = string[0].replace(/^\s*document\.write\(JSON\.parse\((.*)\)\s*\)\s*$/, '$1')

  json = json.replace(/<[^<>]*>/g, '')

  json = json.split '\\\\n'

  csequence = []

  for line in json when line.trim().length > 0 and line.trim() not in ['Powered by Genius', 'Lin-Manuel Miranda']
    if line.indexOf('[') > -1 or line.indexOf(']') > -1
      continue
    else
      csequence.push line
  sequences.push csequence

fs.writeFileSync 'sequence.json', JSON.stringify sequences
