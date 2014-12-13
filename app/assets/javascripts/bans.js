var getUsers = function(request, response) {
    if(!request.term) {
        return;
    }
    var form_fields = $('#new_ban').find('input,select').not('[data-protected=true]');
    form_fields.prop('disabled', true);
    $.getJSON('search?include_proposal=true&search_query=' + request.term, function(result) {
        var names = [];
        $.each(result, function (i, user) {
            names.push({
                label: user.name,
                value: user.name,
                proposal: user.proposal
            });
        });
        form_fields.removeProp('disabled');
        response(names);
    });
};
