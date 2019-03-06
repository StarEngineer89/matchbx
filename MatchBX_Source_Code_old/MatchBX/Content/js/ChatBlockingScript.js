
function checkIfEmailInString(_formatText)
{
    _formatText = _formatText.split(" ").join("")
    var re = /(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/;
    return re.test(_formatText);
}

function CheckPhone(_formatText)
{
    _formatText = _formatText.replace(/[^0-9]/g, '')
    var re=/(?:(?:\+?([1-9]|[0-9][0-9]|[0-9][0-9][0-9])\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([0-9][1-9]|[0-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?/;
    return re.test(_formatText);
}

function FilterText(_formatText)
{
    _formatText = _formatText.toLowerCase();
    var substrings = ['@','email','gmail'];
    length = substrings.length;
    while(length--) {
        if (_formatText.indexOf(substrings[length]) != -1) {
            return true;
        }
    }

    return false;
}