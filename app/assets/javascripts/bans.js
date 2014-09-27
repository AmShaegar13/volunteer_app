var getUsers = function(request, response) {
    if(!request.term) {
        return;
    }
    $.getJSON('search?search_query=' + request.term, function(result) {
        var names = [];
        $.each(result, function (i, name) {
            names.push({
                label: name,
                value: name
            });
        });
        response(names);
    });
};
