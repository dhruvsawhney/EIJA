// (function($) {})(jQuery);

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
    iuUpdate();
    bindGroupToggle();

});

/*
    Above is pro hax
    why it works has something to do with confirming that JQuery is loaded before the
    execution of code
    however as a web dev I have never seen this before in any other framework
    another hack that works is to inline script
    but this is terrible style
 */

/**
 * Globals
 * payloadG = list to contain words to be modified
 */
var heartBeat = 10000; //update UI every second
var payLoadG = [];
var out = {
        "meta" : {
            "playID" : 1, //should not be hardcoded
            "editID" : 1, //Xans gon take u Xans gonna betray u
            "groupNum": getCookie("group_number"),
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
        var scenceId = this.id.slice(5); //slices off scene of scene2 to give 2 or other number
        console.log(scenceId);
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
            function() {
                var classofElement = $(this).attr("class");//get class of current element
                console.log(classofElement);
                setCutUncut(classofElement);//sets global and returns weather we are cutting or nah
                var cutingOrNah = out["meta"]["cutOrUncut"];
                if ($.inArray(this.id, payLoadG) === -1){
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
                        console.log(this.id);
                        payLoadG.push(this.id);
                        cutOrUncutUiInteractionUpdate(cutingOrNah, this);
                    }
                }

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
 *
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
 *
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
 *
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
                "playID" : 1, //should not be hardcoded
                "editID" : 1, //Xans gon take u Xans gonna betray u
                "cutOrUncut" : null, //tells u if its cut or uncut
                "groupNum": getCookie("group_number")
            },
            "payload" : payLoadG
        };
    })
}




/**
 * updates UI based on server response this is the heart and soul of the
 * app this is the litteral heart beat of the app
 */
function iuUpdate() {
    console.log($(".playEditId"));
    $.ajax({
        method: "POST",
        url: '/update/show',
        data: {
            "meta": {
                "editID" : $(".playEditId")[0].id,
                "sceneID" : 1, //FIX ME ALASDAIR IS LAZY
                 "groupNum": getCookie("group_number")
            }
        }
    }).done(function(data){
            console.log("success");
            renderHelper(data);
            setTimeout(
                function()
                {
                    iuUpdate()
                }, heartBeat);
    });


    }

/*
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





/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function groupDropdown() {
    document.getElementById("myDropdown").classList.toggle("show");
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {

    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}

/**
 * its admrible
 */
function bindGroupToggle()
{
$(".groupToggle").click(function(){
    document.cookie="group_number=" + parseInt(this.id.slice(5)) + ";path=/";
    });
}


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

//work on how to build payload

    // $(".PlaySection").mousedown(function () {
    //     console.log("down Detected");
    //     console.log(parseInt(this));
    //     $( ".word" ).hover(
    //         function() {
    //             console.log("hover on");
    //             $( this ).append( $( "<span> ***</span>" ) );
    //         }, function() {
    //             $( this ).find( "span:last" ).remove();
    //         }
    //     );




    // })
//}




// function renderHelper(scenceId) {
//     $.ajax({
//         type: "GET",
//         url: '/scene_render/' + scenceId,
//         success: function(data) {
//             console.log("data");
//             var play =$("#PlaySection");
//             play.html("");//clear previous data
//             play.html(data);//load new scene
//         },
//         complete: function() {
//             console.log("completed");
//             $('.sceneMenu').click(function () {
//                 console.log("rebind");
//                 renderScene();
//             }); // will fire either on success or error
//         }
//     });
// }


// //Create events for the various functions associated with strikethrough.
//
// //If we click the mouse down, tell the program we're dragging the mouse.
// document.querySelector(".script-main").addEventListener("mousedown", drag, false);
//
// //If we move the mouse over an element, let it know. If the mouse is down, this will strikethrough the element.
// //document.querySelector(".script-main").addEventListener("mouseover", doCut, false);
//
// //If the mouse is clicked down over an element, cut the element.
// // document.querySelector(".script-main").addEventListener("mousedown", doCut, false);
//
// //If the mouse is lifted, tell the program that we're no long dragging the mouse.
// document.querySelector(".script-main").addEventListener("mouseup", lift, false);
//
// //Stop cutting or uncutting if the mouse leaves the document or window.
// $(document).mouseleave(function()
// {
//     lift();
// });
//
// document.querySelector(".toggle-button").addEventListener("click",toggleScript, false);
//
// document.querySelector(".save-button").addEventListener("click", saveWrapper, false);
// var mousedrag = false;
// var origId = 0;
// var cutlist = [];
// var uncutlist = [];
// var checkId = "";
// var compressed = false;
//
// //Credit to Odin Thunder https://stackoverflow.com/questions/45349885/how-to-resend-a-failed-ajax-request-globally
// //If a server call fails, try again.
// $( document ).ajaxError( function( event, jqxhr, settings, thrownError) {
//     console.log(settings);
//     $.ajax(settings);
// });
//
// //Save that the mouse is down.
// function drag(e)
// {
//     mousedrag = true;
//     origId = parseInt(e.target.id);
// }
//
// //Save that the mouse is up.
// function lift(e)
// {
//     doCut(e);
//     mousedrag = false;
// }
//
// //A filter which removes the word given.
// function remove(word)
// {
//     return word != checkId;
// }
//
// //Manage the data necessary to cut or uncut a word.
// function dataCut(clickedItem,cut)
// {
//     var idNum = parseInt(clickedItem.id);
//     checkId = idNum;
//     if(cut)
//     {
//         cutlist = cutlist.filter(remove);
//         cutlist.push(idNum);
//     }
//     else
//     {
//         uncutlist = uncutlist.filter(remove);
//         uncutlist.push(idNum);
//     }
// }
//
//
// function saveWrapper()
// {
//
//     if(cutlist.length > 0 || uncutlist.length > 0){
//         var modal3 = document.getElementById("save-modal");
//         modal3.style.display = "block";
//         saveCut();
//     }
// }
//
//
// //If the save button is hit, send cached data to the database.
// function saveCut()
// {
//     var script = $(".script-main")[0];
//     var cEditId = parseInt(script.id);
//     if(cutlist.length == 0 && uncutlist.length == 0){
//         var modal3 = document.getElementById("save-modal");
//         modal3.style.display = "none";
//         window.alert("Saved!");
//         return;
//     }
//
//     if(cutlist.length != 0)
//     {
//         idNum = cutlist.pop();
//         var cutmessage = "Cut: " + idNum.toString();
//         console.log(cutmessage);
//         $.post("/cuts/new",
//             {
//                 editI: cEditId,
//                 wordI: idNum
//             },function()
//             {
//                 saveCut();
//             });
//         return;
//     }
//     if(uncutlist.length != 0)
//     {
//         idNum = uncutlist.pop();
//         var cutmessage = "Uncut: " + idNum.toString();
//         console.log(cutmessage);
//         $.post("/cuts/delete",
//             {
//                 editI: cEditId,
//                 wordI: idNum
//             },function()
//             {
//                 saveCut();
//             });
//         return;
//     }
// }
//
// //Changes visuals of a word.
// function modifyStyle(clickedItem,color,style,cut)
// {
//     clickedItem.style.color = color;
//     clickedItem.style.textDecoration = style;
//     clickedItem.dataset.cut = cut;
// }
//
// //Actually executes the XML cut on a word based on whether it was cut before or not.
// function literalCut(clickedItem,cut)
// {
//     var color;
//     var style;
//     var currId = parseInt(clickedItem.id);
//     console.log("ORIG ID: " + origId);
//     console.log("CURR ID: " + currId);
//     if(cut)
//     {
//         style = "line-through";
//         if(clickedItem.getAttribute("class") == "cword" || clickedItem.getAttribute("class") == "cstage")
//         {
//             color = "#D3D3D3";
//         }
//         else
//         {
//             color = "#888888";
//         }
//     }
//     else
//     {
//         style = "none";
//         if(clickedItem.getAttribute("class") == "cword" || clickedItem.getAttribute("class") == "cstage")
//         {
//             color = "#006BFF";
//         }
//         else
//         {
//             color = "#000000";
//         }
//     }
//     while(origId <= currId){
//         currObj = document.getElementById(origId.toString());
//         modifyStyle(currObj,color,style,cut);
//         dataCut(currObj,cut);
//         console.log("cutting word with id " + origId);
//         origId++;
//     }
// }
//
// // all words will need to be printed within the div class "script-main"
// function doCut(e) {
//     var clickedItem = e.target;
//     // Strikesthrough lines if mouse is down, and unstrikes if shift is also held.
//     if (clickedItem.getAttribute("class") == "word" || clickedItem.getAttribute("class") == "punc"
//         || clickedItem.getAttribute("class") == "cword" || clickedItem.getAttribute("class") == "stage" || clickedItem.getAttribute("class") == "cstage")
//     {
//         if (mousedrag && !e.shiftKey) {
//             literalCut(clickedItem,true);
//         }
//         else if(e.shiftKey && mousedrag) {
//             literalCut(clickedItem,false);
//         }
//     }
// }
//
// function toggleScript(e)
// {
//     if(compressed)
//     {
//         $(".script-second").hide();
//         document.getElementById("toggle-text").textContent="HIDE CUTS";
//         $(".script-main").show();
//     }
//     else
//     {
//         //Got hide syntax from https://stackoverflow.com/questions/9456289/how-to-make-a-div-visible-and-invisible-with-javascript
//         document.getElementById("toggle-text").textContent="SHOW CUTS";
//         var location = ("/edits/compress/").concat(window.location.pathname.substring(7,window.location.pathname.length)).concat(" .script-second");
//         $(".script-second").load(location, function()
//         {
//             $(".script-main").hide();
//             $(".script-second").show();
//         });
//     }
//     compressed = !compressed;
// }