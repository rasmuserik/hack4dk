# API for Jacob and Bo
w = 300
h = 600
margin = .1
dist = (a,b) -> (Math.abs(a[i]-b[i]) for i in [0,a.length-1]).reduce(((a,b)->a+b), 0)
window.isThatKindOfImage = (url, callback) ->
  img = new Image(url)
  img.src = url
  img.onload = ->
    canvas = document.createElement "canvas"
    canvas.width = w
    canvas.height = h
    ctx = canvas.getContext "2d"
    ctx.drawImage img, -w*(1+margin), -h*margin, w*(1+margin)*2, h*(1+2*margin)
    imData = ctx.getImageData 0,0,w,h
    
    vector = []
    scale = 60
    for x in [0..w-1] by scale
      for y in [0..h-1] by scale
        sum = 0
        for dx in [0..scale-1]
          for dy in [0..scale-1]
            sum += if imData.data[((x+dx) + (y+dy)*w)*4] > 128 then 1 else 0
        vector.push sum
    d = dist(vector, [3465, 3557, 3600, 3555, 3474, 3419, 3470, 3531, 3600, 3540, 3450, 3324, 3571, 3464, 3215, 3159, 2971, 3330, 3600, 3315, 3600, 3144, 3233, 3325, 3086, 3366, 2816, 3378, 3275, 3600, 3600, 3243, 3548, 3419, 2819, 3378, 2824, 3445, 3575, 3600, 3600, 3600, 3600, 3473, 3212, 3422, 3262, 3556, 3600, 3600])
    callback d > 120, url
