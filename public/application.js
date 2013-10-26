$(document).ready(function() {

  $(document).on("click","form#hit_form button", function(){
    alert("player hit!!");

    $.ajax({
      type: "POST",
      url: "/hit"
    }).done(function(msg) {
      alert(msg);
      $("#game").replaceWith(msg);
    });

    return false;
  });
});