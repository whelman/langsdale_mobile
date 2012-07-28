// GLOBAL
//-------

///*
window.onload = init;
function init() {
    // loads cookie and displays or hides elements according the kiosk setup
	if (document.cookie.indexOf("kioskLayoutState") >= 0) { 
		var kioskLayoutStateTemp = document.cookie.split("=")[1];
		if (kioskLayoutStateTemp == "on") {
			//alert(kioskLayoutStateTemp);
			document.getElementById("myFooter").style.display = "none";
			document.getElementById("title_for_the_rest").style.display = "none";
			document.getElementById("title_for_ipad").style.display = "block";
		}
	}
	// 
}
//*/

