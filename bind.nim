import nimLUA, nimBMP, nimAES, nimSHA2, streams

proc main() =
  var L = newNimLua()

  L.bindObject(AESContext -> "AES"):
    initAES
    setEncodeKey
    setDecodeKey
    encryptECB
    decryptECB
    cryptOFB
    encryptCBC
    decryptCBC
    encryptCFB128
    decryptCFB128
    encryptCFB8
    decryptCFB8
    cryptCTR
  
  L.bindObject(SHA256):
    initSHA
    update
    final
    
  L.bindObject(BMP):
    decodeBMP
    loadBMP
    convertTo32Bit
    convertTo24Bit
    convert
  
  L.bindFunction("BMP"):
    loadBMP32
    loadBMP24

main()