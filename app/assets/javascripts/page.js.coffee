# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
cached = {}
portlait_db = {}

mobile = ->
    user_agent = navigator.userAgent
    user_agent.indexOf('iPhone') > -1 or user_agent.indexOf('iPad') > -1 or user_agent.indexOf('MSIE') > -1

open_index = ->
  history.replaceState("","","/") unless mobile()
  $.get("/", (data)->
    $("#content").html(data)
  )

max_page = ->
  parseInt($("#max_page").text())-1

left = ->
  if is_left()
    prev()
  else
    next()
right = ->
  if is_left()
    next()
  else
    prev()
plus1 = ->
  open_page(now()+1)

next = ->
  if is_portlait() and $("#area img").attr("class") == "portlait"
    open_page(now()+2)
  else
    open_page(now()+1)
prev = ->
  if is_portlait() and $("#area img").attr("class") == "portlait"
    open_page(now()-2)
  else
    open_page(now()-1)

open_page = (page)->
  $.get("/save_recent/"+_id()+"?page="+page).success((data)->)
  $("#page_jump").val(page)
  if page > max_page()
    page = max_page()
  page = 1 if is_NaN(page) or page < 1
  _now(page)
  history.replaceState null, "page", "/read/"+_id()+"?page="+page unless mobile()
  landscape(page) unless is_portlait()
  portlait(page) if is_portlait()

open_page_loop = ->
  setTimeout ->
    open_page_loop()
  ,50

img_style = (mode)->
  if mode == "portlait"
    "max-height:"+(height()-5)+"px; max-width:"+((width()/2)-10)+"px"
  else
    "max-height:"+(height()-5)+"px; max-width:"+(width()-10)+"px"


landscape = (page)->
  $("#area").html("<div id='page_insert'/>")
  unless cached[page]
    img = "<img src='/image?id="+_id()+"&page="+page+"' class='landscape' style='"+img_style("")+"'/>"
    $("#page_insert").after(img)
  else
    node = $ "#cached_"+page
    $("#page_insert").after node
    $("#area img").removeAttr "id"
    $("#area img").attr "style", img_style("landscape")
    $("#area img").removeAttr "class"
    $("#cached_"+page).remove()
    cached[page] = undefined
  $("#area img").click(-> next())

portlait = (page)->
  $("#area").html("<div id='page_insert'/>")
  if localStorage["portlait/"+_id()+"/"+page] != undefined and localStorage["portlait/"+_id()+"/"+(page+1)] != undefined
    portlait_real(page)
  else
    $.get("/info/"+_id()+"?page="+page).success((data)->
      localStorage["portlait/"+_id()+"/"+(page)] = data.portlait
      $.get("/info/"+_id()+"?page="+(page+1)).success((data)->
        localStorage["portlait/"+_id()+"/"+(page+1)] = data.portlait
        portlait_real(page)
      )
    )

portlait_real = (page) ->
  if localStorage["portlait/"+_id()+"/"+page] == 'true' or localStorage["portlait/"+_id()+"/"+(page+1)] == 'true'
    img = "<img src='/image?id="+_id()+"&page="+page+"' class='landscape' style='"+img_style("")+"'/>"
    $("#page_insert").after(img)
    $("#area img").click(-> next())
    $("#cached_"+page).remove()
    cached[page] = undefined
  else
    if is_left()
      img = "<img src='/image?id="+_id()+"&page="+page+"' class='portlait' style='"+img_style("portlait")+"'/>"
      img += "<img src='/image?id="+_id()+"&page="+(page+1)+"' class='portlait' style='"+img_style("portlait")+"'/>"
    else
      img = "<img src='/image?id="+_id()+"&page="+(page+1)+"' class='portlait' style='"+img_style("portlait")+"'/>"
      img += "<img src='/image?id="+_id()+"&page="+page+"' class='portlait' style='"+img_style("portlait")+"'/>"
    $("#page_insert").after(img)
    $("#area img").click(-> next())
    $("#cached_"+page).remove()
    cached[page] = undefined
    $("#cached_"+page+1).remove()
    cached[page+1] = undefined


cache_loop = ->
  setTimeout ->
    pages = [1,2,3,4,5]
    $.each(pages, ->
      c = this+now()
      unless cached[c] or c > max_page()
        img = "<img src='/image?id="+_id()+"&page="+c+"' class='cache' id='cached_"+c+"'/>"
        $("#cache_insert").after(img)
        cached[c] = true
    )
    cache_loop()
  , 500

size_loop = (size)->
  setTimeout ->
    unless size == undefined or window_size() == undefined
      if size.width != window_size().width or size.height != window_size().height
        size = window_size()
        open_page(now())
    size_loop(size)
  ,500

portlait_loop = (i)->
  setTimeout ->
    unless i > max_page()
      if localStorage["portlait/"+_id()+"/"+i] == undefined
        $.get("/info/"+_id()+"?page="+i).success((data)->
          localStorage["portlait/"+_id()+"/"+i] = data.portlait
          portlait_loop(i+1)
        )
      else
        portlait_loop(i+1)
  ,0

change_bound = ->
  $.get("/page/change_bound/"+_id()).success(->
    if is_left()
      $("#is_left").text("")
      open_page(now())
    else
      $("#is_left").text("true")
      open_page(now())
    if is_left()
      $("#bound").text("Left Side")
    else
      $("#bound").text("Right Side")
  )

swipe_left = ->
  right()
swipe_right = ->
  left()

initialize_read = ->
  if is_left()
    $("#bound").text("Left Side")
  else
    $("#bound").text("Right Side")
  $('body').keyup((e)-> key_queue.push e.keyCode)
  $("#bound").click(-> change_bound())
  size = window_size()
  cache_loop()
  open_page(parseInt $("#page_initial").text())
  size_loop(window_size())
  $("#left").click(-> left())
  $("#right").click(-> right())
  $("#plus1").click(-> plus1())
  $("#area").swipe({swipeLeft:swipe_left, swipeRight:swipe_right, threshold:0})
  $("#book_list").unbind()
  $("#book_list").click -> open_index()
  $("#jump").click ->
    open_page(parseInt($("#page_jump").val()))
  portlait_loop(1)
  
  true
search_word = ""

initialized_index = ->
  $(".link_to").unbind()
  $(".link_to").click(->
    id = $(this).attr("id").split("_")[2]
    $.get("/read/"+id, (data)->
      $("#content").html(data)
      initialize_read()
    )
  )
  $(".link_to_page").unbind()
  $(".link_to_page").click(->
    id = $(this).attr("id").split("_")[1]
    page = $(this).attr("id").split("_")[2]
    $.get("/read/"+id, (data)->
      $("#content").html(data)
      $("#page_initial").text(page)
      initialize_read()
    )
  )

search_loop = ->
  setTimeout ->
    if $("#action").text() == "index"
      if $("#word").val() != search_word and $("#word").val() != ""
        search_word = $("#word").val()
        $.getJSON("/search?id="+encodeURIComponent(search_word)).success((data)->
          $("#area").html(data.html)
          initialized_index()
        ).error(->
          search_loop()
        )
        search_loop()
      else
        search_loop()
    else
      search_loop()
  ,500

key_queue = []

key_loop = ->
  setTimeout ->
    if key_queue.length > 0
      key = key_queue.shift()
      if $("#action").text() == "read"
        if key == 74
          next()
        else if key == 75
          prev()
    key_loop()
  ,500
$(->
  if $("#action").text() == "read"
    initialize_read()
  key_loop() 
  initialized_index() if $("#action").text() == "index"
  search_loop()
  
)
