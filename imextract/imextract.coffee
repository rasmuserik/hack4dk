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
    callback 120 < dist(vector, [3313, 3565, 3600, 3555, 3430, 3424, 3463, 3508, 3600, 3511, 3187, 3357, 3581, 3404, 3099, 3208, 3007, 3354, 3600, 3337, 3566, 3262, 3320, 3290, 3038, 3320, 2949, 3381, 3368, 3560, 3600, 3338, 3561, 3404, 2917, 3298, 2956, 3425, 3580, 3600, 3600, 3600, 3600, 3478, 3262, 3426, 3315, 3554, 3600, 3600]), url
