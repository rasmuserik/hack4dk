#
# util {{{1
log = (a) -> console.log a; a
sleep = (timeout, fn) -> setTimeout fn, timeout*1000
reverse = (arr) -> result = (e for e in arr); result.reverse(); result
nextTick = (fn) -> setTimeout fn, 0
xmlEscape = (str) -> str.replace(/&/g, "&amp;").replace(/</g,"&lt;")#{{{2
pickRand = (arr) -> arr[Math.random() * arr.length | 0]
jsonml2xml = (jsonml) ->#{{{2
  return (xmlEscape jsonml) if typeof jsonml == "string"
  return String(jsonml) if typeof jsonml == "number"
  result = "<" + jsonml[0]
  pos = 2
  if jsonml[1]?.constructor == Object
    for key, val of jsonml[1]
      result += " #{key}=\"#{val}\""
  else
    pos = 1

  return result + ">" if pos == jsonml.length

  result += ">"

  while pos < jsonml.length
    result += jsonml2xml jsonml[pos]
    ++pos
  return result + "</#{jsonml[0]}>"

#code{{{1
currentImage = undefined
yearWidth = undefined
yearLeft = undefined

for image in images
  years = image.year.match(/[0-9]+/g)
  image.startYear = years[0]
  image.endYear = years[years.length - 1]

slider = ->
  log ["div", {class: "yearContainer"}, ["br"],
    ["div", {class: "yearBox"}].concat (
      ["span", {class: "year"}, year] for year in [1300..1900] by 100)]



showQuestion = (image) -> #{{{2
  currentImage = image
  for elem in document.getElementsByClassName "main"
    elem.style.opacity = 0
    elem.style.WebkitOpacity = 0
  sleep 1, ->
    elem = document.getElementById("question")
    elem.innerHTML = jsonml2xml ["div",
      ["h1", {class: "header"}, "When was"],
      ["img", {src: image.src}],
      ["div", {class: "control"},
        slider(),
        ["div", {class: "creator"}, reverse(image.creator.split(",")).join(" ")],
        ["div", {class: "title"}, image.title]]
      ["div", {id: "yearChoice"}, ""]
    ]
    ($ "img").on "load", doLayout
    doLayout()
    elem.style.opacity = 1
    elem.style.WebkitOpacity = 1

doLayout = -> #{{{2
  ($ "img").on "load", -> sleep 1, doLayout
  h = window.innerHeight
  w = window.innerWidth
  landscape = w > h
  x0 = 0
  y0 = 0
  h -= 5
  y0 += 5
  ($ ".creator").css "text-align", "right"
  ($ ".main").css
    position: "absolute"
    top: 0
    left: 0
    width: w
    height: h

  ($ "h1").css
    position: "absolute"
    top: 0
    left: 0
    color: "#363"

  if landscape
    ($ "h1").css
      transformOrigin: "0% 0%"
      transform: "matrix(0,-1,1,0,0,0)"
      top: ($ "h1").width()
    x0 += ($ "h1").height() * 1.2
    w -= ($ "h1").height() * 1.2
  else
    ($ "h1").css
      transformOrigin: "0% 100%"
      transform: "matrix(1,0,0,1,0,0)"
    y0 += ($ "h1").height() * 1.2
    h -= ($ "h1").height() * 1.2

  uiHeight = 120
  x0 += w *.05
  w *= 0.9


  $img = $ "img"
  scale = 1

  #$img.css
  #  width: "auto"
  #  height: "auto"
  if $img.width() then nextTick ->
    iw = $img.width()
    ih = $img.height()
    scale = w/iw if iw > w
    scale *= (h-uiHeight)/(scale*ih) # if scale * ih > h - uiHeight
    iw = $img.width() * scale
    ih = $img.height() * scale
    $img.css log
      position: "absolute"
      top: Math.round(y0)
      left: Math.round(x0 + (w-iw)/2)
      width: Math.round(iw)
      height: Math.round(ih)
    ($ ".control").css
      position: "absolute"
      top: Math.round(y0+ih)
      left: yearLeft = Math.round(x0)
      width: Math.round(w)
    ($ ".year").css
      fontSize: "70%"
      display: "inline-block"
      width: yearWidth = (((w/7) |0) - 1)
      borderLeft: "1px solid black"
      margin: 0
      padding: 0
      height: 25
      paddingTop: 5
    ($ ".yearBox").css
      border: "1px solid black"
      borderLeft: 0
      border: 0
      padding: 0
      borderRadius: 5
      marginTop: 3
      marginBottom: 3
      boxShadow: "5px 5px 10px rgba(255,255,255,.8) inset," +
                 "-5px -5px 10px rgba(0,0,0,.4) inset," +
                 "0px 0px 10px rgba(255,255,0,1)"
      overflow: "hidden"
    ($ ".creator").css
      fontWeight: "bold"
      display: "inline-block"
      float: "right"
    ($ "body").css
      font: "sans-serif"
      background: "#fed"
    ($ "#yearChoice").css
      display: "inline-block"
      transition: "all 1s"
      position: "absolute"
      textAlign: "center"
      top: y0
      color: "#C0FFEE"
      left: x0
      width: w
      font: "#{Math.min(h/4, w/6)}px sans-serif"
      textShadow: "0px 0px 20px rgba(0,0,0,1)," +
        "0px 0px 10px rgba(0,0,0,1)"




# Handle Event {{{1

calcYear = (x,y) ->
  Math.floor((x - yearLeft) * 100/50 / yearWidth) * 50 + 1300

currentYear = undefined
rightAnswers = 0
wrongAnswers = 0

updateYear = (x,y) ->
  currentYear = year = calcYear(x,y)
  elem = document.getElementById "yearChoice"
  elem.innerHTML = year

touched = false
handleStart = (x,y) ->
  updateYear(x,y)
  console.log "start", calcYear(x,y)
  touched = true

handleMove = (x,y) ->
  return if !touched
  updateYear(x,y)
  console.log calcYear(x,y)

handleEnd = (x,y) ->
  touched = false
  console.log "end"
  console.log currentImage, currentYear
  elem = document.getElementById "yearChoice"
  if currentImage.startYear > currentYear + 50 or currentImage.endYear < currentYear
    elem.innerHTML = "Forkert, skabt #{currentImage.year}"
    elem.style.color = "#F00"
    ++wrongAnswers
  else
    elem.innerHTML = "Rigtigt skabt #{currentImage.year}"
    elem.style.color = "#6c6"
    ++rightAnswers
  sleep 2, ->
    showQuestion pickRand images


$ -> #{{{2
  ($ window).on "resize", doLayout
  showQuestion pickRand images
  window.ontouchstart = (e) -> handleStart e.touches[0]?.clientX, e.touches[0]?.clientY
  window.onmousedown = (e) -> handleStart e.clientX, e.clientY
  window.onmouseup = handleEnd
  window.ontouchrelease = handleEnd
  window.ontouchmove = (e) -> handleMove e.touches[0]?.clientX, e.touches[0]?.clientY
  window.onmousemove = (e) -> handleMove e.clientX, e.clientY
