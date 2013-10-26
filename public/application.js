$(document).ready(function() {

  $(document).on("click","form#hit_form button", function(){
    $.ajax({
      type: "POST",
      url: "/hit"
    }).done(function(msg) {
      $("#game").replaceWith(msg);
    });

    return false;
  });

  $(document).on("click","form#stay_form button", function(){
    $.ajax({
      type: "POST",
      url: "/stay"
    }).done(function(msg) {
      $("#game").replaceWith(msg);
    });

    return false;
  });

  $(document).on("click","form#hit_dealer button", function(){
    $.ajax({
      type: "POST",
      url: "/hit_dealer"
    }).done(function(msg) {
      $("#game").replaceWith(msg);
    });

    return false;
  });

});