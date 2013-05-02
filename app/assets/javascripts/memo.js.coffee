$ ->
  click_on '#memo_mode', ->
    $.get('/memo/get_memo', {id: $('#id').text(), page: now()}).success((data)->
      $('#is_memo').text 'true'
      $('#area').after(
        $('<textarea>').height($('#area').height()).width($(window).width()/2-10).css('float', 'left')
      )
    )
