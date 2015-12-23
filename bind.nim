import nimLUA, "nimPDF/nimBMP", "nimPDF/nimAES", "nimPDF/nimSHA2", streams, "nimPDF/nimPDF"
import basic2d

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
    writePDF
    drawText
    drawVText
    beginText
    moveTextPos
    setTextRenderingMode
    setTextMatrix
    showText
    setTextLeading
    moveToNextLine
    endText
    setCharSpace
    setTextHScale
    setWordSpace
    setTransform
    rotate
    move
    scale
    stretch
    skew
    toUser
    fromUser
    drawImage
    drawRect
    moveTo
    lineTo
    bezierCurveTo
    curveTo1
    curveTo2
    closePath
    roundRect
    drawEllipse
    drawCircle
    setLineWidth
    setLineCap
    setLineJoin
    setMiterLimit
    setGrayFill
    setGrayStroke
    setRGBFill
    setRGBStroke
    setCMYKFill
    setCMYKStroke
    setAlpha
    setBlendMode
    saveState
    restoreState
    getTextWidth
    getTextHeight
    clip
    executePath
    drawBounds
    fill
    stroke
    fillAndStroke
    setGradientFill
    makeXYZDest
    makeFitDest
    makeFitHDest
    makeFitVDest
    makeFitRDest
    makeFitBDest
    makeFitBHDest
    makeFitBVDest
    makeOutline
    linkAnnot
    textAnnot
    setPassword
    setEncryptionMode
    initAcroForm
    textField
    drawArc
    arcTo
    setDash

    #addPage

  L.bindObject(AcroForm):
    setFontColor
    setFontSize
    setFontFamily
    setFontStyle
    setEncoding


main()