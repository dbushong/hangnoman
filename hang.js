// Generated by CoffeeScript 1.10.0
(function() {
  var guess, playSound, restoreGame, switchState, updateMissed, updateSolution,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  playSound = function(snd) {
    return $("#" + snd)[0].play();
  };

  switchState = function(state) {
    localStorage.state = state;
    $('.state').removeClass('active');
    return $(".state." + state).addClass('active');
  };

  updateSolution = function() {
    var $s, $w, c, i, j, len, len1, ref, s, word;
    s = localStorage.solution;
    if (s == null) {
      return;
    }
    c = 'A';
    while (c <= 'Z') {
      if (indexOf.call(localStorage.guessed, c) < 0) {
        s = s.replace(new RegExp(c, 'g'), '_');
      }
      c = String.fromCharCode(c.charCodeAt(0) + 1);
    }
    $s = $('#solution').empty();
    ref = s.split(' ');
    for (i = 0, len = ref.length; i < len; i++) {
      word = ref[i];
      $w = $('<span>').addClass('word');
      for (j = 0, len1 = word.length; j < len1; j++) {
        c = word[j];
        $('<span>').addClass('char').text(c).appendTo($w);
      }
      $s.append($w);
    }
    if (!/_/.test(s)) {
      localStorage.state = 'won';
      return playSound('rimshot');
    }
  };

  updateMissed = function() {
    return $('#missed').text(localStorage.missed.split('').sort().join(''));
  };

  guess = function(c) {
    if (!/[A-Z]/.test(c)) {
      return;
    }
    if (indexOf.call(localStorage.guessed, c) >= 0 || indexOf.call(localStorage.missed, c) >= 0) {
      playSound('doink');
      return;
    }
    if (localStorage.solution.indexOf(c) > -1) {
      playSound('drip');
      localStorage.guessed += c;
      return updateSolution();
    } else {
      playSound('grumble');
      localStorage.missed += c;
      return updateMissed();
    }
  };

  restoreGame = function() {
    updateSolution();
    updateMissed();
    return switchState(localStorage.state);
  };

  $(function() {
    var k, ref, v;
    if (localStorage.state === 'playing' && confirm('Resume game in progress?')) {
      restoreGame();
    } else {
      ref = {
        state: 'splash',
        solution: null,
        guessed: '',
        missed: ''
      };
      for (k in ref) {
        v = ref[k];
        localStorage[k] = v;
      }
    }
    $('.splash.state').click(function() {
      switchState('start');
      return $('#enter-solution').focus();
    });
    $('.start.state form').submit(function(e) {
      e.preventDefault();
      localStorage.solution = $('#enter-solution').val().toUpperCase().replace(/\s\s+/g, ' ').replace(/_/g, '');
      if (/[A-Z]/.test(localStorage.solution)) {
        updateSolution();
        return switchState('playing');
      } else {
        return $('#enter-solution').val('');
      }
    });
    $('#enter-solution').keydown(function(e) {
      if (e.which === 13) {
        e.preventDefault();
        return $('.start.state form').submit();
      }
    });
    return $(document).keydown(function(e) {
      if (localStorage.state !== 'playing') {
        return;
      }
      guess(String.fromCharCode(e.which));
      return $('#entry').blur();
    });
  });

}).call(this);
