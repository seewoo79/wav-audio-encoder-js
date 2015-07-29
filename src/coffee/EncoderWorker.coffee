importScripts 'WavAudioEncoder.min.js'

encoder = undefined
buffers = undefined

self.onmessage = (event) ->
  data = event.data
  switch data.command
    when 'start'
      encoder = new WavAudioEncoder data.sampleRate, data.numChannels
      buffers = if data.process == 'separate' then [] else undefined
    when 'record'
      if buffers?
        buffers.push data.buffers
      else
        encoder.encode data.buffers
    when 'finish'
      if buffers?
        encoder.encode buffers.shift() while buffers.length > 0
      self.postMessage blob: encoder.finish()
      encoder = undefined
    when 'cancel'
      encoder.cancel()
      encoder = undefined
  return