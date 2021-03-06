MEDUSA.config.index = function() {
    if ($('input[name="proxy_setting"]').val().length === 0) {
        $('input[id="proxy_indexers"]').prop('checked', false);
        $('label[for="proxy_indexers"]').hide();
    }

    $('#theme_name').on('change', function() {
        api.patch('config/main', {
            theme: {
                name: $(this).val()
            }
        }).then(function(response) {
            log.info(response);
            window.location.reload();
        }).catch(function(err) {
            log.error(err);
        });
    });

    $('input[name="proxy_setting"]').on('input', function() {
        if ($(this).val().length === 0) {
            $('input[id="proxy_indexers"]').prop('checked', false);
            $('label[for="proxy_indexers"]').hide();
        } else {
            $('label[for="proxy_indexers"]').show();
        }
    });

    $('#log_dir').fileBrowser({
        title: 'Select log file folder location'
    });
};
