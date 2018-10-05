function checkAutorefresh() {

    $.get({
        dataType: "json",
        url: "/random"},
        function(data, status) {
            $("#fortune").text(data["fortune"]);
            $("#backendInstance").text(data["instance_id"]);
            $("#backendStack").text(data["stack"]);
    });

    setInterval(autorefresh, 1000);
}

function autorefreshClicked() {
    var checkBox = document.getElementById("autorefresh");

    // Remove the 'auto' param from the search path but
    // keep all other params
    if (!checkBox.checked) {
        var reqURL = new URL(location.href);
        var query_string = reqURL.search;
        var params = new URLSearchParams(query_string);
        params.delete('auto');
        reqURL.search = params.toString();
        var newURL = reqURL.toString();
        window.location.href = newURL;
    }
}

function autorefresh() {
    var checkBox = document.getElementById("autorefresh");

    // Rebuild the search path, setting the auto param but
    // keeping all other params
    var reqURL = new URL(location.href);
    var query_string = reqURL.search;
    var params = new URLSearchParams(query_string); 
    params.set('auto', checkBox.checked);
    reqURL.search = params.toString();
    var newPath = reqURL.pathname + reqURL.search;

    if (checkBox.checked) {
        window.location.href = newPath;
    }
}