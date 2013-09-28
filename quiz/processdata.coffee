fs = require "fs"
file = fs.readFileSync __dirname + "/imgdata-da.txt", "utf8"
rows = file.split "\n"
rows = rows.map (row) -> row.split("|").map((a)->a.trim())
data = []
datum = []
for row in rows
  if row[1] == "[pic]"
    data.push datum
    year = row[4]
    datum =
      src: "smk/" + row[2] + ".jpg"
      title: row[3]
      year: row[4]
      creator: row[5]
  else
    datum.title += " " + row[3]
    datum.creator += " " + row[5]

data[0] = datum

result = []
for datum in data
  result.push datum if fs.existsSync datum.src

fs.writeFile "images.js", "window.images=#{JSON.stringify result}"
console.log img.src for img in result
