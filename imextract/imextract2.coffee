# Images {{{1
imgs = ("imgs/#{name}" for name in [
#  "007534061_00001.jpg",
#  "007534061_00002.jpg",
#  "007534061_00003.jpg",
#  "007534061_00004.jpg",
#  "007534061_00005.jpg",
#  "007534061_00006.jpg",
#  "007534061_00007.jpg",
#  "007534061_00008.jpg",
#  "007534061_00009.jpg",
#  "007534061_00010.jpg",
#  "007534061_00011.jpg",
#  "007534061_00012.jpg",
#  "007534061_00013.jpg",
#  "007534061_00014.jpg",
#  "007534061_00015.jpg",
#  "007534061_00016.jpg",
#  "007534061_00017.jpg",
#  "007534061_00018.jpg",
#  "007534061_00019.jpg",
#  "007534061_00020.jpg",
#  "007534061_00021.jpg",
#  "007534061_00022.jpg",
#  "007534061_00023.jpg",
  "007534061_00024.jpg",
  "007534061_00025.jpg",
  "007534061_00026.jpg",
  "007534061_00027.jpg",
  "007534061_00028.jpg",
  "007534061_00029.jpg",
  "007534061_00030.jpg",
  "007534061_00031.jpg",
  "007534061_00032.jpg",
  "007534061_00033.jpg",
  "007534061_00034.jpg",
  "007534061_00112.jpg"])
# {{{1
reverse = (arr) ->
  result = []
  result.push arr[i] for i in [arr.length-1..0]
  result

# {{{1

$ ->
  for img in imgs
    handleImage img

nextId = 0
w = 300
h = 200
count = 0
handleImage = (url) ->
  console.log url
  img = new Image(url)
  img.src = url
  img.onload = ->
    id = nextId++
    canvas = document.createElement "canvas"
    canvas.style.width = (canvas.width = w) + "px"
    canvas.style.height = (canvas.height = h) + "px"
    ctx = canvas.getContext "2d"
    ctx.drawImage img, 0, 0, w, h
    imData = ctx.getImageData 0,0,w,h
    rows = []
    cols = []
    data = new Uint8Array(w *h)
    for x in [0..w-1]
      for y in [0..h-1]
        p = imData.data[4*x + y*w*4]
        rows[y] = (rows[y] | 0) + p
        cols[x] = (cols[x] | 0) + p
        data[x+w*y] = if p > 128 then 0 else 255
    maxrows = Math.max.apply Math, rows
    maxcols = Math.max.apply Math, cols
    rows = rows.map (a) -> a / maxrows > .8
    cols = cols.map (a) -> a / maxcols > .8
    findStart = (arr) ->
      for i in [0..arr.length-1]
        return i if arr[i]
    console.log maxrows, maxcols, rows, cols
    [y0, y1] = [(findStart rows), (rows.length - 1 - findStart reverse rows)]
    [x0, x1] = [(findStart cols), (cols.length - 1 - findStart reverse cols)]
    ctx.fillStyle = "rgba(255,255,0,.5)"
    ctx.fillRect x0, y0, x1-x0, y1-y0
    for x in [0..w-1]
      for y in [0..h-1]
        if x < x0 or x > x1 or y < y0 or y > y1
          data[x+w*y] = 0
    blit = (buf, w, h) ->
      for x in [0..w-1]
        for y in [0..h-1]
          pos = (x+y*w) * 4
          imData.data[pos] = imData.data[pos+1] = imData.data[pos+2] = buf[x+y*w]
          imData.data[pos+4] = 255
      ctx.putImageData(imData,0,0)
    blit data, w, h

    blur = 6
    for x in [0..w-1-blur]
      for y in [0..h-1]
        data[x + y*w] = (data[x+w*y+i] for i in [0..blur]).reduce(((a,b)->Math.max(a,b)), 0)
    for x in [0..w-1]
      for y in [0..h-1-blur]
        data[x + y*w] = (data[x+w*(y+i)] for i in [0..blur]).reduce(((a,b)->Math.max(a,b)), 0)
    blit data, w, h

    document.body.appendChild canvas
    if ++count == imgs.length
      loadDone()
