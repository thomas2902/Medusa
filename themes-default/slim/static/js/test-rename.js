$(document).ready(() => {
    $('.seriesCheck').on('click', function() {
        const serCheck = this;

        $('.seasonCheck:visible').each(function() {
            this.checked = serCheck.checked;
        });

        $('.epCheck:visible').each(function() {
            this.checked = serCheck.checked;
        });
    });

    $('.seasonCheck').on('click', function() {
        const seasCheck = this;
        const seasNo = $(seasCheck).attr('id');

        $('.epCheck:visible').each(function() {
            const epParts = $(this).attr('id').split('x');

            if (epParts[0] === seasNo) {
                this.checked = seasCheck.checked;
            }
        });
    });

    $('input[type=submit]').on('click', () => {
        const epArr = [];

        $('.epCheck').each(function() {
            if (this.checked === true) {
                epArr.push($(this).attr('id'));
            }
        });

        if (epArr.length === 0) {
            return false;
        }

        window.location.href = $('base').attr('href') + 'home/doRename?indexername=' + $('#indexer-name').attr('value') +
            '&seriesid=' + $('#series-id').attr('value') + '&eps=' + epArr.join('|');
    });
});
