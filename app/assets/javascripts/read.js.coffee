window.Comic = ->
  @portlait_db = {}
  @is_left = -> $("#is_left").text() == "true"
  @page_initial = parseInt $("#page_initial").text()
  @if_ie = navigator.userAgent.toLowerCase().indexOf('msie') != -1
  @id = $('#id').text()
  @w = new WindowSize()
  @max_page = parseInt($("#max_page").text())-1
  @init = =>
    if @is_left()
      $("#bound").text("Left Side")
    else
      $("#bound").text("Right Side")
    size = @w.window_size()
    @get_portlait()
    @open_page @page_initial
    @ms_swipe_loop()
    @size_loop(@w.window_size())
    @area_width_loop(0)
    if window.navigator.msPointerEnabled
      @ms_swiper($('#area').get(0))
    else
      $("#area").swipe({swipeLeft:@swipe_left, swipeRight:@swipe_right, threshold:0})
    $("#book_list").off()
    click_on "#bound", => @change_bound()
    click_on "#left", => @left()
    click_on "#right", => @right()
    click_on "#plus1", => @plus1()
    click_on "#jump", => @open_page(parseInt($("#page_jump").val()))
    click_on '#area', => @next() unless window.navigator.msPointerEnabled

  @save_recent = (page)=>$.get("/save_recent/#{@id}?page=#{page}").success((data)->)
  @set_now = (str)-> $("#now").text(str)
  @now = ->
    count = parseInt($("#now").text())
    if is_NaN(count) then 0 else return count
  @get_portlait = => $.each JSON.parse($('#info').text()), (page,portlait)=> localStorage.setItem "portlait/#{@id}/#{page}", portlait

  @set_memo_page = (page)=>
    href = $('#memo_link').attr('original') + "/?page=#{page}"
    $('#memo_link').attr(href: href)
  
  @open_page = (page)=>
    @set_memo_page page
    @save_recent page
    $("#page_jump").val(page)
    page = @max_page if page > @max_page
      
    page = 1 if is_NaN(page) or page < 1
    @set_now(page)
    @remover(page-1)
    history.replaceState null, "page", "/read/#{@id}?page=#{page}" if history.replaceState
    for i in [0,1,2,3,4,5,6,7]
      unless document.querySelector('#page_area_'+(page+i))
        @landscape(page+i) unless @w.is_portlait()
        @portlait(page+i) if @w.is_portlait()
  @remover = (i)=>
    if i >= 0
      $('#page_area_'+(i)).remove()
      @remover(i-1)

  @landscape = (page)=>
    $('#area').height(@w.height()-5)
    $img = $("<img>").attr(src: "/image?id=#{@id}&page=#{page}", class: 'landscape', style: @img_style('')).outerHTML()
    img = $('<div class="img_area" id="page_area_'+page+'">'+img+'</div>')
    $div = $('<div>').attr(class: 'img_area', id: "page_area_#{page}").html($img).css('z-index': 100000000-page,  position: 'absolute')
    $("#page_insert").after($div)
    @img_ms_swiper()
  @img_style = (mode)=>
    if mode == "portlait"
      "max-height:#{@w.height()-5}px; max-width:#{(@w.width()/2)-20}px"
    else
      "max-height:#{@w.height()-5}px; max-width:#{@w.width()-20}px"

  @portlait = (page)=>
    if localStorage["portlait/#{@id}/#{page}"] != undefined and localStorage["portlait/#{@id}/#{page+1}"] != undefined
      @portlait_real(page)
    else
      $.get("/info/#{@id}?page=#{page}").success (data)=>
        localStorage["portlait/#{@id}/#{page}"] = data.portlait
        $.get("/info/#{@id}?page=#{page+1}").success (data)=>
          localStorage["portlait/#{@id}/#{page+1}"] = data.portlait
          @portlait_real(page)
    
  @is_portlait_image = (page)->localStorage["portlait/#{@id}/#{page}"] == 'true' or localStorage["portlait/#{@id}/#{page+1}"] == 'true'
  
  @portlait_real = (page)=>
    if @is_portlait_image(page)
      img =$("<img>").attr(src: "/image?id=#{@id}&page=#{page}", style: @img_style(''), class: 'landscape').outerHTML()
    else
      if @is_left()
        img = $("<img>").attr(src: "/image?id=#{@id}&page=#{page}", style: @img_style('portlait'), class: 'portlait', id: page).outerHTML()
        img += $("<img>").attr(src: "/image?id=#{@id}&page=#{page+1}", style: @img_style('portlait'), class: 'portlait', id: page+1).outerHTML()
      else
        img =$("<img>").attr(src: "/image?id=#{@id}&page=#{page+1}", style: @img_style('portlait'), class: 'portlait', id: page+1).outerHTML()
        img += $("<img>").attr(src: "/image?id=#{@id}&page=#{page}", style: @img_style('portlait'), class: 'portlait', id: page).outerHTML()
    $('#area').height(@w.height()-5)
    $div = $('<div>').attr(class: 'img_area', id: "page_area_#{page}").html(img).css 'z-index': 100000000-page,  position: 'absolute'
    $("#page_insert").after($div)
    @img_ms_swiper()
  @img_ms_swiper = =>
    for n in $('#area img')
      @ms_swiper(n)
  @area_pointer = {x: 0, y: 0}
  @ms_swipe = ''
  @ms_swiper = (e)=>
    if window.navigator.msPointerEnabled
      $(e).css('-ms-touch-action': 'none', '-ms-user-select': 'none')
      e.removeEventListener('MSPointerDown',arguments.callee, false)
      e.removeEventListener('MSPointerUp',arguments.callee, false)
      e.addEventListener('MSPointerDown', (e)=>
        if @area_pointer.x == 0 and @area_pointer.y == 0
          @area_pointer.x = e.clientX
          @area_pointer.y = e.clientY
      )
      e.addEventListener('MSPointerUp', (e)=>
        if e.clientY - @area_pointer.y < 500 and @area_pointer.y - e.clientY < 500
          if @area_pointer.x - e.clientX > 50
            @ms_swipe = 'left' if @ms_swipe == ''
          if e.clientX - @area_pointer.x > 50
            @ms_swipe = 'right' if @ms_swipe == ''
        else
          @ms_swipe = 'down' if @ms_swipe == ''
        @area_pointer.x = 0
        @area_pointer.y = 0
      )
  @ms_swipe_loop = =>
    setTimeout =>
      if @ms_swipe == 'right'
        @ms_swipe = ''
        @swipe_right()
      if @ms_swipe == 'left'
        @ms_swipe = ''
        @swipe_left()
      if @ms_swipe == 'down'
        @ms_swipe = ''
        $('html,body').animate({ scrollTop: 1000000000 }, 'fast')
      @ms_swipe_loop()
    ,200

  @size_loop = (size)=>
    setTimeout =>
      unless size == undefined or @w.window_size() == undefined
        if Math.floor(size.width) != Math.floor(@w.width()) or Math.floor(size.height) != Math.floor(@w.height())
          size = @w.window_size()
          $('.portlait').attr 'style', @img_style('portlait')
          $('.landscape').attr 'style', @img_style('landscape')
          $('#area').height(@w.height()-5)
      @size_loop(size)
    ,500

  @area_width_loop = (size) =>
    if @if_ie
      time = 1000
    else
      time = 100
    setTimeout =>
      unless document.querySelector('.img_area')
        @area_width_loop(0)
      else
        count = $('.img_area').last().width()
        count = ($('#area').width()-count)/2
        count = Math.floor count
        size = Math.floor size
        if @if_ie
          for n in $('img.portlait')
            img_width = Math.floor ($('#area').width()-count*2)/2
            $(n).width(img_width).attr(width: img_width)
        if size != count
          $('.img_area').css('left', count)
          
          @area_width_loop(count)
        else
          $('.img_area').css('left', size)
          @area_width_loop(size)
    , time


  @change_bound = =>
    $.get("/page/change_bound/#{@id}").success =>
      @remover @max_page
      if @is_left()
        $("#is_left").text("")
        @open_page(@now())
      else
        $("#is_left").text("true")
        @open_page(@now())
      if @is_left()
        $("#bound").text("Left Side")
      else
        $("#bound").text("Right Side")

  # 操作関連
  @next = => if(@w.is_portlait() and $("#area img").attr("class") == "portlait") then @open_page(@now()+2) else @open_page(@now()+1)
  @plus1 = => @open_page(@now()+1)
  @prev = => if(@w.is_portlait() and $("#area img").attr("class") == "portlait") then @open_page(@now()-2) else @open_page(@now()-1)
  @left = => if @is_left() then @prev() else @next()
  @right = => if @is_left() then @next() else @prev()
  @swipe_left = => @right()
  @swipe_right = => @left()

  this

ready = ->
  if $('#action').text() == 'read'
    c = new Comic()
    c.init()
    window.next = c.next
    window.prev = c.prev
    window.plus1 = c.plus1

$(document).ready(ready)
$(document).on('page:change', ready)

