switchState = (state) ->
  localStorage.state = state
  $('.state').removeClass 'active'
  $(".state.#{state}").addClass 'active'

updateSolution = ->
  s = localStorage.solution
  return unless s?
  c = 'A'
  while c <= 'Z'
    s = s.replace new RegExp(c, 'g'), '_' unless c in localStorage.guessed
    c = String.fromCharCode(c.charCodeAt(0) + 1)
  $('#solution').text s
  unless /_/.test s
    localStorage.state = 'won'
    alert('You win!')

updateMissed = ->
  $('#missed').text localStorage.missed.split('').sort().join('')

guess = (c) ->
  if !/[A-Z]/.test(c) or c in localStorage.guessed or c in localStorage.missed
    return
  if localStorage.solution.indexOf(c) > -1
    localStorage.guessed += c
    updateSolution()
  else
    localStorage.missed += c
    updateMissed()

restoreGame = ->
  updateSolution()
  updateMissed()
  switchState localStorage.state

$ ->
  if localStorage.state is 'playing' and confirm 'Resume game in progress?'
    restoreGame()
  else
    localStorage[k] = v for k, v of {
      state:    'splash'
      solution: null
      guessed:  ''
      missed:   ''
    }

  $('.splash.state').click ->
    switchState 'start'
    $('#enter-solution').focus()

  $('.start.state form').submit (e) ->
    e.preventDefault()
    localStorage.solution = $('#enter-solution').val()
      .toUpperCase().replace(/\s\s+/g, ' ').replace(/_/g, '')
    if /[A-Z]/.test localStorage.solution
      updateSolution()
      switchState 'playing'
    else
      $('#enter-solution').val ''

  $('#entry').keydown (e) ->
    e.preventDefault()
    guess String.fromCharCode e.which
    $(this).blur()
