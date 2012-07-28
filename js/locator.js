// run when page loads
window.onload = init;

function init() { 
    //load data from web service
    var source = "json/langsdale_sections.json";
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.open("GET",source,false);
    xmlhttp.send("");
    sections = JSON.parse(xmlhttp.responseText);
	
    // inspect find button
    var findBook = document.getElementById("findBook");
    findBook.onclick = findTheBook;
}

function findTheBook() { // evaluate the textbox, find and display the stack
    // get call number from textbox
    var callNumber = document.getElementById("callNumber").value;
    var callNumber = callNumber.toUpperCase();
    document.getElementById("callNumber").value = callNumber;
    //alert(normalizeLC(callNumber));
    var inStock = function(callNumber) {
        foundBook = false;
        for (var i=0; i < sections.length; i++) { 
            var beginSection = sections[i].begin, endSection = sections[i].end, book = callNumber;
            if (normalizeLC(book) >= normalizeLC(beginSection) && normalizeLC(book) <= normalizeLC(endSection)) {
                //alert(" book: "+normalizeLC(book)+" / begin: "+normalizeLC(beginSection)+" / end: "+normalizeLC(endSection));
                sectionFound = sections[i];
                foundBook = true;
            }
        }
        return foundBook;
    }
    var inStock = inStock(callNumber);
    if (inStock == true) {
        // only if the call number was found
        sectionLocationX = sectionFound.location_x;
        sectionLocationY = sectionFound.location_y;
        sectionSizeW = sectionFound.size_w;
        sectionSizeH = sectionFound.size_h;
        // show canvas wrapper and message
        document.getElementById('myBodyPage').scrollIntoView();
        document.getElementById("mapWrapper").style.display = "none";
        document.getElementById("loading").style.display = "block";
        setTimeout(function() {
            document.getElementById("loading").style.display = "none";                
            document.getElementById("mapWrapper").style.display = "block";                
            // iniciate canvas 
            var myMap=document.getElementById("myMap");
            var ctx=myMap.getContext("2d");
            // iniciate PNG map
            var imageMap=new Image();
            // display map
            imageMap.src = "images/book_locator_map.png";
            imageMap.onload = function() {
                ctx.drawImage(imageMap,0,0);
                ctx.fillStyle = "#FFFF00"; // yellow
                ctx.fillRect(sectionLocationX-7,sectionLocationY,sectionSizeW+14,sectionSizeH);
                ctx.fillStyle = "#990000"; // red
                ctx.fillRect(sectionLocationX,sectionLocationY,sectionSizeW,sectionSizeH);
                ctx.font="bold 8pt Arial";
                ctx.fillStyle="#FFFFFF"; //white
                ctx.textAlign="center";
                ctx.fillText(sectionFound.section,sectionLocationX+(sectionSizeW/2),sectionLocationY+8);
                ctx.font="normal 13pt Monotype";
                ctx.fillStyle="#990000"; // red
                ctx.textAlign="center";
                ctx.fillText(callNumber,225,230);
                ctx.font="normal 10pt Arial";
                ctx.fillText("Find your book in",225,252);
                ctx.fillText("SECTION: "+sectionFound.section,225,275);
            };
        },600);
        latestSearches(sectionFound.section,callNumber);
    }
    if (inStock == false) { // only if the call number wasn't found
        document.getElementById("mapWrapper").style.display = "none";
    }
}