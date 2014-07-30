Resize = ->
  @window_height = 0
  @window_width = 0
  @image_height = 0
  @size_changed = =>
    if @window_width != $(window).width()
      return true
    if $(window).height() != @window_height
      return true
    if $('#memo #image img').height() != @image_height
      return true
    return false

  @resize = =>
    if @size_changed()
      @window_width = $(window).width()
      @window_height =$(window).height()
      @set_image_size()
      @set_form_size()

  @set_image_size = =>
    $('#memo #image').css(width: @window_width/2, height: @window_height-20)

  @set_form_size = =>
    $('#form').css(width: @window_width/2-20)
    $('#form textarea').css(height: $('#memo #image img').height()-6)
  @loop = =>
    @resize()
    setTimeout(=>
      @loop()
    , 200)
  return this
Memo = ->
  @body = $('#body').val()
  @save = =>
    @body = $('#body').val()
    $.post(location.href, body: @body).success((data)=>
      @re_loop()
    )
  @loop = =>
    if @body != $('#body').val()
      @save()
    else
      @re_loop()
  @re_loop = =>
    setTimeout(=>
      @loop()
    ,200)
  @start = =>
    console.log 'Start Memo Mode'
    resize = new Resize()
    resize.loop()
    @loop()
  return this

$ ->
  if $('#controller').text() == 'page' and $('#action').text() == 'memo'
    memo = new Memo()
    memo.start()
