# トップページの検索関連

search_word = ""

search_loop = ->
  setTimeout ->
    if $("#action").text() == "index"
      if $("#word").val() != search_word and $("#word").val() != ""
        search_word = $("#word").val()
        $.getJSON("/search?id="+encodeURIComponent(search_word)).success((data)->
          if search_word == $("#word").val() and $('#word').val() == data.query
            $("#area").html(data.html)
        ).error(->
          search_loop()
        )
        search_loop()
      else
        search_loop()
    else
      search_loop()
  ,500

$ ->
  search_loop()
