state    = 'splash'
solution = null
guessed  = []
missed   = []

switchState = (newState) ->
  state = newState
  $('.state').removeClass 'active'
  $(".state.#{state}").addClass 'active'

updateSolution = ->
  c = 'A'
  s = solution
  while c <= 'Z'
    s = s.replace new RegExp(c, 'g'), '_' unless c in guessed
    c = String.fromCharCode(c.charCodeAt(0) + 1)
  $('#solution').text s
  alert('You win!') unless /_/.test s

guess = (c) ->
  return if !/[A-Z]/.test(c) or c in guessed or c in missed
  if solution.indexOf(c) > -1
    guessed.push c
    updateSolution()
  else
    missed.push c
    $('#missed').text missed.sort().join('')

$ ->
  $('.splash.state').click ->
    switchState 'start'
    $('#enter-solution').focus()

  $('.start.state form').submit (e) ->
    e.preventDefault()
    solution = $('#enter-solution').val()
      .toUpperCase().replace(/\s\s+/g, ' ').replace(/_/g, '')
    if /[A-Z]/.test solution
      updateSolution()
      switchState 'playing'
    else
      $('#enter-solution').val ''

  $('#entry').keydown (e) ->
    e.preventDefault()
    guess String.fromCharCode e.which
    $(this).blur()
