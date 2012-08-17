$('#github_info').submit(function() { // catch the form's submit event
    $.ajax({ // create an AJAX call...
        data: $(this).serialize(), // get the form data
        type: $(this).attr('method'), // GET or POST
        url: $(this).attr('action'), // the file to call
        success: function(response) { // on success..
            $('#copyfield').html(response); // update the DIV
        }
    });
    $('#copyfield').show()
    return false; // cancel original event to prevent form submitting
});
