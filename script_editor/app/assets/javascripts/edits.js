// This is the most important file in th whole app so read it and understand it
// If you dont know JS its ok Im amazing at commenting
// Also read examples
// And stackoverflow
// Jquery docs are some of the best around but I still hate reading so you know
// life advice be aggressively lazy

$(function() {
    $(document).ready(function() {
        console.log("set up");
        $('.accordion').find('.accordion-toggle').click(function() {
            $(this).next().slideToggle('600');
            $(".accordion-content").not($(this).next()).slideUp('600');
        });
        $('.accordion-toggle').on('click', function() {
            $(this).toggleClass('active').siblings().removeClass('active');
        });
        //renderHelper(1);//this will need to be fixed later
        detectSelections();


    });
    analytics();
    renderScene();
    iuUpdate(true, true);
    bindGroupToggle();

});

/*
    Above is pro hax
    why it works has something to do with confirming that JQuery is loaded before the
    execution of code
    however as a web dev I have never seen this before in any other framework
    another hack that works is to inline script
    but this is terrible style
    also if u can figure this out u have more time and are more diligent than me
    so good for u I guess
    I'll buy you a burrito hit me up Alasdair Johnson like no joke do it
    well become friends and walk into the sunset
 */

/**
 * Globals
 * payloadG = list to contain words to be modified
 */
var heartBeat = 10000000; //update UI every milliseconds
var payLoadG = [];
var out = {
        "meta" : {
            "playID" : getCookie("play_id"), //should not be hardcoded
            //"editID" : 1, //Xans gon take u Xans gonna betray u
            "groupNum": getCookie("group_num"),
            "cutOrUncut" : null //tells u if its cut or uncut
        },
        "payload" : payLoadG
    };

/**
 * The bellow method binds the Anyalicts element to the analytis modal so when
 * it is clicked the modal will open and render with the most current data from the
 * server
 */
function analytics() {
    $("#play-analytics").click(function () {
        $.get('/analytics_modal/show')//get HTML to insert
            .done(function(data)
            {
                var play =$("#analyticsBody");
                play.html("");//clear previous data
                play.html(data);//load new scene
                bindQueScript();//bind button
            });
        $("#analytics-modal").modal("show");
    })

}

/**
 * Analytics bind
 * so this will bind the button to forward you to the appropriate que script
 * the musics load and im feeling load, If I break your heart Im a dumb dude
 */

function bindQueScript() {
    $("#cueScriptSelect").click(function () {
        var charName = $("#queScriptNameSelector option:selected")[0].value
        console.log(charName);
        window.location.href='/script/' + charName;
    })
}

/**
 * Will handel loading difrent scences into the Play area
 */
function renderScene()
{
    $(".sceneMenu").click(function () {
        console.log(this.id);
        var scenceId = this.id; //slices off scene of scene2 to give 2 or other number
        ScenerenderHelper(scenceId);
    })

};

function ScenerenderHelper(scenceId) {
    $.get('/scene_render/' + scenceId)//get HTML to insert
        .done(function(data)
        {
            // console.log(data);
            var play =$("#PlaySection");
            play.html("");//clear previous data
            play.html(data);//load new scene
            detectSelections(); // bind to scence
        });
}
/**
 * This method handels detecting what selection the user is making
 * to the text so if they want to cut we need to know what they are selecting
 * so here is what we do. Say you click then every element you drag over will then
 * be added to a seleciton when you lift your mouse up Ill make and AJAX call
 * to the server and say hey this fool deleted x words and the server will say chill
 * once this handshake bettwen client and server is complet we will be able to confirm that
 * a valid edit was made cool
 * Boss like to dog I been ready my click been ready I got go get it my name gonna hold up my team
 * gonna hold up miss me with that ... Im not a gang member Im a tourist
 *
 * mabey you and I were ment to be Im crazy you aint by tokens no more you just role at the rink
 */
function detectSelections() {
    $(".word")
        .mousedown(function() {
            console.log("down Detected");
            console.log(this);
            addToPayload(this)//this is a hack but hell it works
            //while the mouse is down
            logWords(true);//we have detected user wants to make changes to selection
        })
        .mouseup(function() {
            //detect when the user lifts the mouse up so that we can stop the selection
            console.log("payload:");
            console.log(payLoadG);
            logWords(false);
        });
}
/**
  *This method logs the work during a selection
  * @param onOff Boolean start and stop tracking hover kind of
 */
function logWords(onOff) {
    if (onOff) {
        $( ".word" ).hover(
            function() {//this function is called while hover is active
               addToPayload(this);
            },
            function() {
                //$( this ).removeClass("del");
            }
        );
    }
    else{
        sendPayload();
        $( ".word" ).off( "mouseenter mouseleave" );
    }
}

/**
 * Add to payload add words to payload and then will
 * also toggle its classe this also sets if we are cutting or uncuting
 */
function addToPayload(payloadElement){
    var classofElement = $(payloadElement).attr("class");//get class of current element
    console.log(classofElement);
    setCutUncut(classofElement);//sets global and returns weather we are cutting or nah
    var cutingOrNah = out["meta"]["cutOrUncut"];
    if ($.inArray(payloadElement.id, payLoadG) === -1){
        console.log(cutingOrNah);
        if ((classofElement === "word") == cutingOrNah){
            //so I know this is hacky as shit but I hope u get it
            //I want the behavior that once I start selecting words that
            //it is locked in that I am cutting or uncuting the words
            //so lets think about that now then so what will happen
            //is if I click a word we will first check to see if the class
            //is 'word' or 'word del' if it is word then
            //
            //check to make sure that this word is not already in the payload
            //if it is unique add it
            console.log("adding :" +
                "");
            console.log(payloadElement.id);
            payLoadG.push(payloadElement.id);
            cutOrUncutUiInteractionUpdate(cutingOrNah, payloadElement);
        }
    }
}


/**
 * will set the globals so that once you start cutting for that payload
 * all will be cuts
 * this is kind of a hack but hey its javascript the whole launge is a hack
 * and dont you think about rewriting this in coffeescript
 */
function setCutUncut(classofElement){
    if (out["meta"]["cutOrUncut"] === null){
        if (classofElement === "word"){//word that is uncut cut it
            out["meta"]["cutOrUncut"] = true;
            //now we know we want to cut words for the rest of this
            // selection we will only allow you to cut words
            console.log(out);
            return true;
        }
        else{
            out["meta"]["cutOrUncut"] = false;
            console.log(out);
            return false
        }
    }


}

/**
 * A wraper so that code is cleaner to toggle the del css class
 */
function cutOrUncutUiInteractionUpdate(cutUncut, element){
    if (cutUncut){
        $( element).addClass("del");
        //strike through word
    }
    else{
        $( element ).removeClass("del");
    }
}

/**
 * sends edit data to server
 * pretty obvious AJAX is cool right
 * learn it
 */
function sendPayload() {

    console.log(out);
    $.ajax({
        method: "POST",
        url: "/cuts/new",
        data: out
    }) .done(function() {
        console.log( "success" );
        payLoadG = [];//reset globals
        out = {
            "meta" : {
                "playID" : getCookie("play_id"), //should not be hardcoded
                //"editID" : 1, //Xans gon take u Xans gonna betray u
                "cutOrUncut" : null, //tells u if its cut or uncut
                "groupNum": getCookie("group_num")
            },
            "payload" : payLoadG
        };
    })
}

/**
 * updates UI based on server response this is the heart and soul of the
 * app this is the litteral heart beat of the app
 * heartBeatOrUpdate: true will cause this function to loop on a globally set interval
 * calling back home to get update
 */
function iuUpdate(heartBeatOrUpdate, getAllOrLastInterval) {
    console.log("play ID");
    console.log(getCookie("play_id"));
   // console.log($(".sceneName")[0].id.slice(9));
    $.ajax({
        method: "POST",
        url: '/update/show',
        data: {
            "meta": {
                //"editID" : $(".playEditId")[0].id,
                "timePeriodFlag": getAllOrLastInterval,
                "sceneID" : $(".sceneName")[0].id.slice(9),
                "groupNum": getCookie("group_num"),
                "playID" : getCookie("play_id"), //should not be hardcoded

            }
        }
    }).done(function(data){
            renderHelper(data);
            if (heartBeatOrUpdate) {
                setTimeout(
                    function()
                    {
                        iuUpdate()
                    }, heartBeat);
            }
            console.log("success");

    });
    }

/**
 * I just want feel liberated
 * this method will take in a edits payload from the 
 * update controller and then will render the updates
 * from the cuts and uncuts onto the page
*/
function renderHelper(uiUpdatesResponse) {
                console.log(uiUpdatesResponse);
                var payload = uiUpdatesResponse["payload"];
                console.log(payload);
                for (i = 0; i < payload["cut"].length; i++) {
                    var CutId = payload["cut"][i];
                    console.log($("#" + CutId));
                    $("#" + CutId).addClass("del");
                }
                for (i = 0; i < payload["uncut"].length; i++) {
                    var UncutId = payload["uncut"][i];
                    console.log($("#" + UncutId));
                    $("#" + UncutId).removeClass("del");
                }

}

/**
 * when the user clicks on the drop down update cookie so they are looking at a diffrent
 * set of edtis
 * also update all edits in view
 */
function bindGroupToggle() {
    $(".groupToggle").click(function(){
        document.cookie = "group_num" + "=" + this.id.slice(5)+ ";path=/";
        $("#dropdownMenuButton").html(this.text);
        //console.log($(".sceneName")[0].id.slice(9));
        ScenerenderHelper($(".sceneName")[0].id.slice(9));
       // iuUpdate(false, false);//lol just saw this name, this will call update once so new edits are
        //reflected on page
    });
}


/** When the user clicks on the button,
 * toggle between hiding and showing the dropdown content
 */
// function groupDropdown() {
//     document.getElementById("myDropdown").classList.toggle("show");
// }
//
// // Close the dropdown menu if the user clicks outside of it
// window.onclick = function(event) {
//   if (!event.target.matches('.dropbtn')) {
//
//     var dropdowns = document.getElementsByClassName("dropdown-content");
//     var i;
//     for (i = 0; i < dropdowns.length; i++) {
//       var openDropdown = dropdowns[i];
//       if (openDropdown.classList.contains('show')) {
//         openDropdown.classList.remove('show');
//       }
//     }
//   }
// }

/**
 * Take the cookiename as parameter (cname).
 *
 * Create a variable (name) with the text to search for (cname + "=").
 *
 * Decode the cookie string, to handle cookies with special characters, e.g. '$'
 *
 * Split document.cookie on semicolons into an array called ca (ca = decodedCookie.split(';')).
 *
 * Loop through the ca array (i = 0; i < ca.length; i++), and read out each value c = ca[i]).
 *
 * If the cookie is found (c.indexOf(name) == 0), return the value of the cookie (c.substring(name.length, c.length).
 *
 * If the cookie is not found, return "".
 * @param cname
 * @returns {string}
 *
 * thanks w3 schools
 *
 * https://www.w3schools.com/js/js_cookies.asp
 */
function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}