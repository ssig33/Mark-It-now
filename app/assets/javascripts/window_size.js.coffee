window.WindowSize = ->
  @height = ->
    if window.innerHeight
      window.innerHeight
    else if document.documentElement && document.documentElement.clientHeight != 0
      document.documentElement.clientHeight
    else if document.body
      document.body.clientHeight
    else
      0
  @width = ->
    if window.innerWidth
      window.innerWidth
    else if document.documentElement && document.documentElement.clientWidth != 0
      document.documentElement.clientWidth
    else if document.body
      document.body.clientWidth
    else
      0

  @is_portlait = => (@height()/@width()) < 1
  @window_size = => {height: @height(), width: @width()}

  this
