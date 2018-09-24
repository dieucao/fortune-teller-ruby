function toggleAuto() {
    var checkBox = document.getElementById("autorefresh");

    if (checkBox.checked == true){
        window.location = "/?auto=true";
    } else {
        window.location = "/";
    }
}