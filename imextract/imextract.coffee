# Images {{{1
imgs = ("imgs/#{name}" for name in [
  "007534061_00001.jpg",
  "007534061_00002.jpg",
  "007534061_00003.jpg",
  "007534061_00004.jpg",
  "007534061_00005.jpg",
  "007534061_00006.jpg",
  "007534061_00007.jpg",
  "007534061_00008.jpg",
  "007534061_00009.jpg",
  "007534061_00010.jpg",
  "007534061_00011.jpg",
  "007534061_00012.jpg",
  "007534061_00013.jpg",
  "007534061_00014.jpg",
  "007534061_00015.jpg",
  "007534061_00016.jpg",
  "007534061_00017.jpg",
  "007534061_00018.jpg",
  "007534061_00019.jpg",
  "007534061_00020.jpg",
  "007534061_00021.jpg",
  "007534061_00022.jpg",
  "007534061_00023.jpg",
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

#$ ->
#  ($ "body").append $ "<div id=a>"
#  ($ "body").append $ "<div id=b>"
#  for img in imgs
#    isThatKindOfImage img, (dist, img) ->
#      ($ "##{if dist then "a" else "b"}").append $ "<img src=#{img} width=40 height=30>"
#      console.log img, dist

nextId = 0
w = 300
h = 600
margin = .1
count = 0
vectors = {}
window.isThatKindOfImage = (url, callback) ->
  img = new Image(url)
  img.src = url
  img.onload = ->
    id = nextId++
    canvas = document.createElement "canvas"
    canvas.style.width = (canvas.width = w) + "px"
    canvas.style.height = (canvas.height = h) + "px"
    ctx = canvas.getContext "2d"
    ctx.drawImage img, -w*(1+margin), -h*margin, w*(1+margin)*2, h*(1+2*margin)
    imData = ctx.getImageData 0,0,w,h
    ctx.fillText url,0,10

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
    vectors[url] = vector
    callback 120 < dist(vector, [3313, 3565, 3600, 3555, 3430, 3424, 3463, 3508, 3600, 3511, 3187, 3357, 3581, 3404, 3099, 3208, 3007, 3354, 3600, 3337, 3566, 3262, 3320, 3290, 3038, 3320, 2949, 3381, 3368, 3560, 3600, 3338, 3561, 3404, 2917, 3298, 2956, 3425, 3580, 3600, 3600, 3600, 3600, 3478, 3262, 3426, 3315, 3554, 3600, 3600]), url
 #   if ++count == imgs.length
 #     loadDone()

dist = (a,b) -> (Math.abs(a[i]-b[i]) for i in [0,a.length-1]).reduce(((a,b)->a+b), 0)

#loadDone = ->
#  return
#  for url1, vec1 of vectors
#    for url2, vec2 of vectors
#      console.log url1, url2, dist(vec1, vec2), vec1

