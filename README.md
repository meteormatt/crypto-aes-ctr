# Crypto AES CTR

[![NPM version](http://img.shields.io/npm/v/crypto-aes-ctr.svg)](https://www.npmjs.com/package/crypto-aes-ctr)

An alternative wrapper around OpenSSL's AES_ctr128_encrypt API that allows one to specify the starting `counter` for AES CTR mode.  This allows one to start reading an AES encrypted file in the middle of the file (i.e. 'seek') vs CBC mode which requires that you start at the beginning.

The `counter` parameter is the AES block index that will be first passed into the stream.  The block size of AES is 128 bits or 16 bytes.  See this [wikipedia page](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation) for more details on how AES CTR mode works.

Make sure you have an OpenSSL library available.  For Windows build, the path assumed to be C:\OpenSSL-Win64 or C:\OpenSSL-Win32 for 64-bit or 32-bit builds respectively.

## Install

```shell
npm install --save crypto-aes-ctr
```

## Usage

```javascript

var cryptoAesCtr = require("crypto-aes-ctr");
var crypto = require("crypto");

// key is a 32 byte buffer
var key = crypto.pbkdf2Sync(password, salt, iterations, 32);

// iv is an 8 byte buffer (it is important that it is random)
var iv = crypto.randomBytes(8);
var cipherStream = cryptoAesCtr.createStream(key, iv);

// pipe encrypted input stream to cipherStream

```

This example works for both encryption and decryption.  There is also no final call because of a lack of padding in CTR mode.

If you would like to start decrypting in the middle file, you just need to pass in a counter to the AES block you are first passing to the stream (starting at zero).

```javascript

// discard 3 AES blocks
var aesBlockSize = 16;
var counter = 3;

// starting in middle of encrypted file
var fileInStream = fs.createReadStream(myFile, { start: (aesBlockSize * counter) });

// ...

// create cipher stream with correct counter
var cipherStream = cryptoAesCtr.createStream(key, iv, counter);

// pipe encrypted input stream to cipherStream
fileInStream.pipe(cipherStream);

```

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)