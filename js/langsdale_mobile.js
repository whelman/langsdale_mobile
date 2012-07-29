// GLOBAL
//-------

///*
window.onload = init;
function init() {
    // loads cookie and displays or hides elements according the kiosk setup
	if (document.cookie.indexOf("kioskLayoutState") >= 0) { 
		var kioskLayoutStateTemp = readCookie("kioskLayoutState");
		if (kioskLayoutStateTemp == "on") {
			//alert(kioskLayoutStateTemp);
			document.getElementById("myFooter").style.display = "none";
			document.getElementById("title_for_the_rest").style.display = "none";
			document.getElementById("title_for_ipad").style.display = "block";
		}
	}
	// loads cookie value
	function readCookie(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
		return null;
	}
	// 
}
//*/
