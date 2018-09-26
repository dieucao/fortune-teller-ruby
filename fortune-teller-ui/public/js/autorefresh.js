function toggleAuto() {
    var checkBox = document.getElementById("autorefresh");

    if (checkBox.checked){
        window.location = "/?auto=true";
    } else {
        window.location = "/";
    }
}