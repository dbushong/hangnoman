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
  $s = $('#solution').empty()
  for word in s.split(' ')
    $w = $('<span>').addClass('word')
    $('<span>').addClass('char').text(c).appendTo($w) for c in word
    $s.append $w
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

  $('#enter-solution').keydown (e) ->
    if e.which is 13
      e.preventDefault()
      $('.start.state form').submit()

  $(document).keydown (e) ->
    return unless localStorage.state is 'playing'
    e.preventDefault()
    guess String.fromCharCode e.which
    $('#entry').blur()
