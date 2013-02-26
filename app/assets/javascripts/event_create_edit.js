//= require countdown_event_name
//= require events
//= require jquery.app
//= require jquery-placeholder

$(document).ready(function(){
  $('#new_event').submit(function(){
    $('.cta').prop('disabled', true);
  });

  var form_clean = $("#new_event").serialize();

  window.onbeforeunload = function(){
    var form_dirty = $("#new_event").serialize();
    if(form_clean != form_dirty){
      return "Your changes will not be saved.";
    }
  }

  $("#new_event").submit(function(){
     window.onbeforeunload = null;
  });
});
