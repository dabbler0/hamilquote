Botkit = require 'botkit'
controller = Botkit.slackbot()

fs = require 'fs'

LENGTH = 4

sequences = JSON.parse fs.readFileSync('sequence.json').toString()
quotes = JSON.parse fs.readFileSync('quotes.json').toString()

quote_attr = []

capitalize = (string) ->
  if string.length is 0
    string
  else
    string[0].toUpperCase() + string[1..].toLowerCase()

for key, val of quotes
  key = key.split(/[^\w]/).map(capitalize).join(', ')
  for quote in val
    quote_attr.push {
      quote: quote
      attribution: key
    }

bot = controller.spawn {
  token: 'xoxb-59934944771-3jkpjcxFoIvyrA1R7kPtEPd4'
}

bot.startRTM (err, bot, playoad) ->
  if err
    throw new Error 'Could not connect to slack.'

events = ['direct_message', 'direct_mention', 'mention', 'ambient']

for event in events
  controller.on event, (bot, message) ->
    if message.text is 'hamilquote'
      quote = quote_attr[Math.floor Math.random() * quote_attr.length]
      console.log 'USING QUOTE', quote
      bot.reply message, "\"#{quote.quote}\" -#{quote.attribution}"
    else
      possible_indices = []
      for sequence, i in sequences
        for line, j in sequence when line.toLowerCase().indexOf(message.text.toLowerCase()) >= 0
          possible_indices.push {i, j}

      if possible_indices.length > 0
        index = possible_indices[Math.floor Math.random() * possible_indices.length]

        response = sequences[index.i][index.j..index.j + LENGTH].join('\n')

        console.log message
        console.log '-----'
        console.log response

        bot.reply message, response
