// GLOBAL
//-------

///*
window.onload = init;
function init() {
    // loads data from web cookie
	if (document.cookie.indexOf("kioskLayoutState") >= 0) { 
		var kioskLayoutStateTemp = document.cookie.split("=")[1];
		if (kioskLayoutStateTemp == "on") {
			//alert(kioskLayoutStateTemp);
			document.getElementById("myFooter").style.display = "none";
		}
	}
}
//*/

