# Data acquisition {{{1

nodes = {}
$ ->
  # lookup page from url {{{2
  query = unescape location.search.slice 1
  $.ajax
    url: "http://en.wikipedia.org/w/api.php"
    cache: true
    data:
      action: "opensearch"
      search: query
      limit: 10
      namespace: 0
      format: "json"
    dataType: "jsonp"
    success: (data) ->
      pageName = data[1][0]
      loadNode pageName, (node) ->
        nodes[pageName] = node
        initDraw()
        expandNodes ->
          pruneNodes()
          console.log nodes

  loadNode = (pageName, done) -> #{{{2
    node =
      name: pageName
      links: []

    dataHandle = (data) ->
      console.log data
      for pageId, page of data.query.pages
        return done node if pageId == "-1"
        for link in page.links
          node.links.push link.title if link.ns == 0
      if data["query-continue"]
        query.data.plcontinue = data["query-continue"].links.plcontinue
        $.ajax query
      else
        done node

    query =
      url: "http://en.wikipedia.org/w/api.php"
      cache: true
      data:
        action: "query"
        titles: pageName
        format: "json"
        prop: "links"
        plnamespace: 0
        pllimit: 500
      dataType: "jsonp"
      success: dataHandle
    
    $.ajax query

  expandNodes = (done) -> #{{{2
    neededNodes = {}
    for _, node of nodes
      for child in node.links
        neededNodes[child] = true
    neededNodes = Object.keys neededNodes
    expand = ->
      draw()
      console.log nodes, neededNodes
      return done() if neededNodes.length == 0
      nodeId = neededNodes.pop()
      return expand() if nodes[nodeId]
      loadNode nodeId, (node) ->
        nodes[nodeId] = node
        expand()
    expand()

  pruneNodes = () -> #{{{2
    names = {}
    for _, node of nodes
      for link in node.links
        if names[link]
          ++names[link]
        else
          names[link] = 1
    names = ({name: name, count: count} for name, count of names)
    names.sort (a, b) ->
      return b.count - a.count
    console.log names.slice(100)

# Draw graph {{{1
#
ctx = undefined
canvas = undefined
force = undefined

initDraw = -> #{{{1

  force = d3.layout.force()
  force.size [window.innerWidth, window.innerHeight]
  force.on "tick", forceTick
  force.charge -400
  force.linkDistance 150
  force.linkStrength 0.3
  force.gravity 0.1

  ($ "body").append $ '<div id="graph"></div>' if !($ "#graph").length
  $("#graph").empty()
  $canvas = $ "<canvas></canvas>"
  $("#graph").append $canvas
  canvas = $canvas[0]
  ctx = canvas.getContext "2d"
  $canvas.css
    position: "absolute"
    top: 0
    left: 0

  # Resize canvas {{{4
  w = window.innerWidth
  h = window.innerHeight
  ctx.width = canvas.width = w
  ctx.height = canvas.height = h
  canvas.style.width = w + "px"
  canvas.style.height = h + "px"


links = undefined

draw = -> #{{{2

  # Update force graph {{{4
  links = []
  nodeList = []
  for _, node of nodes
    nodeList.push node
    for link in node.links
      if nodes[link]
        links.push
          source: node
          target: nodes[link]

  force.nodes nodeList
  force.links links
  force.start()

forceTick = -> #{{{3

  ctx.lineWidth = 0.3
  ctx.clearRect 0, 0, canvas.width, canvas.height

  nodeList = (node for _, node of nodes)
  nodeList.reverse()
  minX = nodeList[0].x
  maxX = nodeList[0].x
  minY = nodeList[0].y
  maxY = nodeList[0].y
  for node in nodeList
    minX = Math.min minX, node.x
    maxX = Math.max maxX, node.x
    minY = Math.min minY, node.y
    maxY = Math.max maxY, node.y

  normX = (x) -> 100 + (x - minX) / (maxX - minX) * (canvas.width - 200)
  normY = (y) -> 10 +  (y - minY) / (maxY - minY) * (canvas.height - 10)

  ctx.beginPath()
  for link in links
    ctx.moveTo (normX link.source.x), (normY link.source.y)
    ctx.lineTo (normX link.target.x), (normY link.target.y)
  ctx.stroke()


  for node in nodeList
    x = normX node.x
    y = normY node.y
    w = (ctx.measureText node.name).width
    x -= w/2
    ctx.fillStyle = 'rgba(255,255,255,.7)'
    ctx.fillRect x - 2, y - 8, w + 4, 10
    ctx.fillStyle = 'rgba(0,0,0,1)'
    ctx.fillText node.name, x, y
