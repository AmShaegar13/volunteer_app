var getUsers = function(request, response) {
    if(!request.term) {
        return;
    }
    $.getJSON('search?include_proposal=true&search_query=' + request.term, function(result) {
        var names = [];
        $.each(result, function (i, user) {
            names.push({
                label: user.name,
                value: user.name,
                proposal: user.proposal
            });
        });
        response(names);
    });
};
