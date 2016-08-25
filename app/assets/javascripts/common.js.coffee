$(document).on 'ready page:load', ->
  $('div.alert-danger').delay(4000).slideUp()
  $('div.alert-success').delay(4000).slideUp()
  $('div.alert-notice').delay(4000).slideUp()
  cancel_function = ->
    window.history.back()
