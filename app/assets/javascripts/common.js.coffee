# イベントの付与。複数イベントの付与を書きやすく。
window.event_on = (selector, events, func)->
  for e in events
    $(document).on e, selector, func

# クリックイベントの付与。
window.click_on = (selector, func)->
  event_on(selector, ['click'], func)
  $(selector).css('cursor', 'pointer')

# モバイル環境かどうか
window.mobile = ->
  user_agent = navigator.userAgent
  user_agent.indexOf('iPhone') > -1 or user_agent.indexOf('iPad') > -1 or user_agent.indexOf('MSIE') > -1
