#util{{{1
xmlEscape = (str) -> str.replace(/&/g, "&amp;").replace(/</g,"&lt;")#{{{2
pickRand = (arr) -> arr[Math.random() * arr.length | 0]
jsonml2xml = (jsonml) ->#{{{2
  return (xmlEscape jsonml) if typeof jsonml == "string"
  result = "<" + jsonml[0]
  pos = 2
  if jsonml[1].constructor == Object
    for key, val of jsonml[1]
      result += " #{key}=\"#{val}\""
  else
    --pos
    pos = 1

  return result + ">" if pos == jsonml.length

  result += ">"

  while pos < jsonml.length
    result += jsonml2xml jsonml[pos]
    ++pos
  return result + "</#{jsonml[0]}>"

#code{{{1
console.log images
image = pickRand images
console.log image
$ ->
  ($ "body").append jsonml2xml ["div",
    ["h1", "When was"],
    ["img", {src: image.src, width:300}],
    ["div", {class: "creator"}, image.creator],
    ["div", {class: "title"}, image.title],
    ["div", {class: "year"}, image.year],
  ]
