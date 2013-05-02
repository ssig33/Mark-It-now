# キーボード操作用
key_queue = []
key_loop = ->
  setTimeout ->
    if key_queue.length > 0
      key = key_queue.shift()
      if $("#action").text() == "read"
        switch key
          when 74
            next()
          when 75
            prev()
          when 80
            plus1()
    key_loop()
  ,50

$ ->
  key_loop()
  $(document).keyup((e)-> key_queue.push e.keyCode)

