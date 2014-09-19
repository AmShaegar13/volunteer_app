$(function() {
    $('#ban_user_id').on('change', function()  {
        latest_ban = $('#ban_user_id option:selected').data('latest-ban');
        console.log(latest_ban);
        next = $('#ban_duration option[value='+latest_ban+']').next().val();
        console.log(next);
        if(next) {
            $('#ban_duration').val(next);
        } else {
            $('#ban_duration').val(-1); // perma
        }
    });
});