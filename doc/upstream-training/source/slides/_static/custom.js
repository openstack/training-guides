function logABug() {
    var lineFeed = "%0A";

    // generate title
    var headings = document.getElementsByTagName('h2');
    var bugTitle;
    if (headings.length > 0) {
        bugTitle = headings[headings.length-1].innerHTML
                   + " in Upstream Training";
    } else {
        bugTitle = document.title + " in Upstream Training";
    }
    // remove unnecessary anchor tag
    bugTitle = bugTitle.replace(/<a [^>]*>/, '');
    bugTitle = bugTitle.replace(/<\/a>/, '');

    // generate location with page number
    var location = window.location.href;
    if (location.indexOf("#") > 0) {
        // remove static page number at the point direct access
        location = location.substring(0,location.indexOf("#"));
    }
    var pageNum  = headings.length + 1;

    // generate bug report link URL
    var bugLink  = "https://bugs.launchpad.net/openstack-training-guides/"
                   + "+filebug?field.title=" + encodeURIComponent(bugTitle)
                   + "&field.comment=" + lineFeed + lineFeed
                   + "----------------------------------------" + lineFeed
                   + "Title: " + encodeURIComponent(bugTitle) + lineFeed
                   + "URL: " + encodeURIComponent(location + "#" + pageNum);

    // generate bug report link
    var elementI = document.createElement('i');
    var attrC1  = document.createAttribute('class');
    attrC1.value  = 'fa fa-bug';
    elementI.setAttributeNode(attrC1);

    var elementA = document.createElement('a');
    var attrC2  = document.createAttribute('class');
    var attrH   = document.createAttribute('href');
    attrC2.value  = 'logabug';
    attrH.value = bugLink;
    elementA.setAttributeNode(attrC2);
    elementA.setAttributeNode(attrH);
    elementA.appendChild(elementI);

    var slides  = document.getElementsByTagName('article');
    slides[slides.length-1].appendChild(elementA);
}
