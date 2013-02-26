//= require countdown_event_name
//= require events
//= require jquery.app
//= require jquery-placeholder

$(document).ready(function(){
  window.onbeforeunload = function(e) {
    return 'Dialog text here.';
  };

  $('#new_event').submit(function(){
    $('.cta').submit(function(){
      window.beforeunload = null;
     });
    $('.cta').prop('disabled', true);
  });
});
