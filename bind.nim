import nimLUA, "nimPDF/nimBMP", "nimPDF/nimAES", "nimPDF/nimSHA2", streams, "nimPDF/nimPDF"

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
    
  L.bindEnum:
    LabelStyle
    PageOrientationType
    CoordinateMode
    DestStyle
  
  L.bindFunction():
    getSizeFromName
    makePageSize
    getVersion
  
  L.bindObject(DocOpt):
    makeDocOpt
    addResourcesPath
    addImagesPath
    addFontsPath
    clearFontsPath
    clearImagesPath
    clearResourcesPath
    clearAllPath
  
  L.bindObject(Document):
    setInfo
    initPDF
    getOpt
    setLabel
    loadImage
    getVersion
    setUnit
    getUnit
    setCoordinateMode
    getCoordinateMode
    getSize
    setFont
    addPage
    writePDF
    

main()