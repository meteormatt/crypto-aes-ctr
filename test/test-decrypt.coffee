cryptoAesCtr = require "../lib"
fs = require "fs"
child_process = require "child_process"

originFile = "test-decrypted.coffee"
encryptedFile = "test-encrypted.enc"
decryptedFile = "test-decrypted.txt"

key = new Buffer("8fbf35890fc3e0d5bc615cb091f16e8d40cfe3d4223cd68b11e2e7204d890210", "hex")
iv = new Buffer("4395a3ded2f0040835d437cc9fa7a7dc", "hex")
aesBlockSize = 16
counter = 3
fileInStream = fs.createReadStream(encryptedFile, {start: aesBlockSize * counter})
fileInStream.once 'readable', () ->

  cipherStream = cryptoAesCtr.createStream key, iv, 0

  fileInStream.pipe(cipherStream)

  cipherStream.once 'readable', () ->

    fileOutStream = fs.createWriteStream(decryptedFile)

    cipherStream.pipe(fileOutStream)

#    fileOutStream.on 'finish', () ->
#      console.log "file decryption finished"
#
#      child_process.exec "cmp #{originFile} #{decryptedFile}", (err, stdin, stdout) ->
#        if err?
#          console.log "passed: origin file and decrypted file are the same"
#        else
#          console.log "failed: origin file and decrypted file are NOT the same"

