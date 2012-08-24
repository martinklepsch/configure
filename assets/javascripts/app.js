mixpanel.track('page viewed', {'page name' : document.title, 'url' : window.location.pathname});
$('#github_info').submit(function() { // catch the form's submit event
    $.ajax({ // create an AJAX call...
        data: $(this).serialize(), // get the form data
        type: $(this).attr('method'), // GET or POST
        url: $(this).attr('action'), // the file to call
        success: function(response) { // on success..
            $('#copyfield').html(response); // update the DIV
        }
    });
    mixpanel.track("clicked Show me");
    $('#copyfield').show()
    return false; // cancel original event to prevent form submitting
});

$('.me').click(function(){
  mixpanel.track("clicked me");
});
$('.gitforked-button').click(function(){
  mixpanel.track("clicked Fork button");
});
$('.me').click(function(){
  mixpanel.track("clicked Tweet button");
});

