fade_flash = ->
  $('#flash_notice').delay(3000).fadeOut 'slow'
  $('#flash_alert').delay(3000).fadeOut 'slow'
  $('#flash_error').delay(10000).fadeOut 'slow'
  return
fade_flash()

show_ajax_message = (msg, type) ->
  $('#flash-message').replaceWith(
      '<div class="row" id="flash-message">' +
        '<div data-alert class="alert-box" id="flash_' + type + '">' + msg +
          '<a href="#" class="close">&times;</a>' +
        '</div>' +
      '</div>')
  fade_flash()
  return

$(document).ajaxComplete (event, request) ->
  msg = request.getResponseHeader('X-Message')
  type = request.getResponseHeader('X-Message-Type')
  if type != null
    show_ajax_message msg, type if msg
  $('#flash-message').replaceWith("<div class='row' id='flash-message'></div>") unless msg
  return