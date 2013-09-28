// Generated by CoffeeScript 1.6.3
(function() {
  var calcYear, currentImage, currentYear, doLayout, handleEnd, handleMove, handleStart, image, jsonml2xml, log, nextTick, pickRand, reverse, rightAnswers, showQuestion, sleep, slider, touched, updateYear, wrongAnswers, xmlEscape, yearLeft, yearWidth, years, _i, _len;

  log = function(a) {
    console.log(a);
    return a;
  };

  sleep = function(timeout, fn) {
    return setTimeout(fn, timeout * 1000);
  };

  reverse = function(arr) {
    var e, result;
    result = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        e = arr[_i];
        _results.push(e);
      }
      return _results;
    })();
    result.reverse();
    return result;
  };

  nextTick = function(fn) {
    return setTimeout(fn, 0);
  };

  xmlEscape = function(str) {
    return str.replace(/&/g, "&amp;").replace(/</g, "&lt;");
  };

  pickRand = function(arr) {
    return arr[Math.random() * arr.length | 0];
  };

  jsonml2xml = function(jsonml) {
    var key, pos, result, val, _ref, _ref1;
    if (typeof jsonml === "string") {
      return xmlEscape(jsonml);
    }
    if (typeof jsonml === "number") {
      return String(jsonml);
    }
    result = "<" + jsonml[0];
    pos = 2;
    if (((_ref = jsonml[1]) != null ? _ref.constructor : void 0) === Object) {
      _ref1 = jsonml[1];
      for (key in _ref1) {
        val = _ref1[key];
        result += " " + key + "=\"" + val + "\"";
      }
    } else {
      pos = 1;
    }
    if (pos === jsonml.length) {
      return result + ">";
    }
    result += ">";
    while (pos < jsonml.length) {
      result += jsonml2xml(jsonml[pos]);
      ++pos;
    }
    return result + ("</" + jsonml[0] + ">");
  };

  currentImage = void 0;

  yearWidth = void 0;

  yearLeft = void 0;

  for (_i = 0, _len = images.length; _i < _len; _i++) {
    image = images[_i];
    years = image.year.match(/[0-9]+/g);
    image.startYear = years[0];
    image.endYear = years[years.length - 1];
  }

  slider = function() {
    var year;
    return log([
      "div", {
        "class": "yearContainer"
      }, ["br"], [
        "div", {
          "class": "yearBox"
        }
      ].concat((function() {
        var _j, _results;
        _results = [];
        for (year = _j = 1300; _j <= 1900; year = _j += 100) {
          _results.push([
            "span", {
              "class": "year"
            }, year
          ]);
        }
        return _results;
      })())
    ]);
  };

  showQuestion = function(image) {
    var elem, _j, _len1, _ref;
    currentImage = image;
    _ref = document.getElementsByClassName("main");
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      elem = _ref[_j];
      elem.style.opacity = 0;
      elem.style.WebkitOpacity = 0;
    }
    return sleep(1, function() {
      elem = document.getElementById("question");
      elem.innerHTML = jsonml2xml([
        "div", [
          "h1", {
            "class": "header"
          }, "When was"
        ], [
          "img", {
            src: image.src
          }
        ], [
          "div", {
            "class": "control"
          }, slider(), [
            "div", {
              "class": "creator"
            }, reverse(image.creator.split(",")).join(" ")
          ], [
            "div", {
              "class": "title"
            }, image.title
          ]
        ], [
          "div", {
            id: "yearChoice"
          }, ""
        ]
      ]);
      ($("img")).on("load", doLayout);
      doLayout();
      elem.style.opacity = 1;
      return elem.style.WebkitOpacity = 1;
    });
  };

  doLayout = function() {
    var $img, h, landscape, scale, uiHeight, w, x0, y0;
    ($("img")).on("load", function() {
      return sleep(1, doLayout);
    });
    h = window.innerHeight;
    w = window.innerWidth;
    landscape = w > h;
    x0 = 0;
    y0 = 0;
    h -= 5;
    y0 += 5;
    ($(".creator")).css("text-align", "right");
    ($(".main")).css({
      position: "absolute",
      top: 0,
      left: 0,
      width: w,
      height: h
    });
    ($("h1")).css({
      position: "absolute",
      top: 0,
      left: 0,
      color: "#363"
    });
    if (landscape) {
      ($("h1")).css({
        transformOrigin: "0% 0%",
        transform: "matrix(0,-1,1,0,0,0)",
        top: ($("h1")).width()
      });
      x0 += ($("h1")).height() * 1.2;
      w -= ($("h1")).height() * 1.2;
    } else {
      ($("h1")).css({
        transformOrigin: "0% 100%",
        transform: "matrix(1,0,0,1,0,0)"
      });
      y0 += ($("h1")).height() * 1.2;
      h -= ($("h1")).height() * 1.2;
    }
    uiHeight = 100;
    x0 += w * .05;
    w *= 0.9;
    $img = $("img");
    scale = 1;
    if ($img.width()) {
      return nextTick(function() {
        var ih, iw;
        iw = $img.width();
        ih = $img.height();
        scale = w / iw;
        if (scale * ih > h - uiHeight) {
          scale *= (h - uiHeight) / (scale * ih);
        }
        iw = $img.width() * scale;
        ih = $img.height() * scale;
        $img.css(log({
          position: "absolute",
          top: Math.round(y0),
          left: Math.round(x0 + (w - iw) / 2),
          width: Math.round(iw),
          height: Math.round(ih)
        }));
        ($(".control")).css({
          position: "absolute",
          top: Math.round(y0 + ih),
          left: yearLeft = Math.round(x0),
          width: Math.round(w)
        });
        ($(".year")).css({
          fontSize: "70%",
          display: "inline-block",
          width: yearWidth = ((w / 7) | 0) - 1,
          borderLeft: "1px solid black",
          margin: 0,
          padding: 0,
          height: 25,
          paddingTop: 5
        });
        ($(".yearBox")).css({
          border: "1px solid black",
          borderLeft: 0,
          border: 0,
          padding: 0,
          borderRadius: 5,
          marginTop: 3,
          marginBottom: 3,
          boxShadow: "5px 5px 10px rgba(255,255,255,.8) inset," + "-5px -5px 10px rgba(0,0,0,.4) inset," + "0px 0px 10px rgba(255,255,0,1)",
          overflow: "hidden"
        });
        ($(".creator")).css({
          fontWeight: "bold",
          display: "inline-block",
          float: "right"
        });
        ($("body")).css({
          font: "sans-serif",
          background: "#fed"
        });
        return ($("#yearChoice")).css({
          display: "inline-block",
          transition: "all 1s",
          position: "absolute",
          textAlign: "center",
          top: y0,
          color: "#C0FFEE",
          left: x0,
          width: w,
          font: "" + (Math.min(h / 8, w / 6)) + "px sans-serif",
          textShadow: "0px 0px 20px rgba(0,0,0,1)," + "0px 0px 10px rgba(0,0,0,1)"
        });
      });
    }
  };

  calcYear = function(x, y) {
    return Math.floor((x - yearLeft) * 100 / 50 / yearWidth) * 50 + 1300;
  };

  currentYear = void 0;

  rightAnswers = 0;

  wrongAnswers = 0;

  updateYear = function(x, y) {
    var elem, year;
    currentYear = year = calcYear(x, y);
    elem = document.getElementById("yearChoice");
    return elem.innerHTML = year;
  };

  touched = false;

  handleStart = function(x, y) {
    updateYear(x, y);
    console.log("start", calcYear(x, y));
    return touched = true;
  };

  handleMove = function(x, y) {
    if (!touched) {
      return;
    }
    updateYear(x, y);
    return console.log(calcYear(x, y));
  };

  handleEnd = function(x, y) {
    var elem;
    touched = false;
    console.log("end");
    console.log(currentImage, currentYear);
    elem = document.getElementById("yearChoice");
    if (currentImage.startYear > currentYear + 50 || currentImage.endYear < currentYear) {
      elem.innerHTML = "Forkert, skabt " + (currentImage.year.toLowerCase());
      elem.style.color = "#F00";
      ++wrongAnswers;
    } else {
      elem.innerHTML = "Rigtigt skabt " + (currentImage.year.toLowerCase());
      elem.style.color = "#6c6";
      ++rightAnswers;
    }
    return sleep(2, function() {
      return showQuestion(pickRand(images));
    });
  };

  $(function() {
    ($(window)).on("resize", doLayout);
    showQuestion(pickRand(images));
    window.ontouchstart = function(e) {
      var _ref, _ref1;
      return handleStart((_ref = e.touches[0]) != null ? _ref.clientX : void 0, (_ref1 = e.touches[0]) != null ? _ref1.clientY : void 0);
    };
    window.onmousedown = function(e) {
      return handleStart(e.clientX, e.clientY);
    };
    window.onmouseup = handleEnd;
    window.ontouchrelease = handleEnd;
    window.ontouchmove = function(e) {
      var _ref, _ref1;
      return handleMove((_ref = e.touches[0]) != null ? _ref.clientX : void 0, (_ref1 = e.touches[0]) != null ? _ref1.clientY : void 0);
    };
    return window.onmousemove = function(e) {
      return handleMove(e.clientX, e.clientY);
    };
  });

}).call(this);
