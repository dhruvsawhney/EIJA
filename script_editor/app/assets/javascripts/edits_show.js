// //Create events for the various functions associated with strikethrough.
//
// //If we click the mouse down, tell the program we're dragging the mouse.
// $(".script-main").mousedown(drag);
// console.log(document)
// console.log($(document).find(".script-main")    );
// //If we move the mouse over an element, let it know. If the mouse is down, this will strikethrough the element.
// //document.querySelector(".script-main").addEventListener("mouseover", doCut, false);
//
// //If the mouse is clicked down over an element, cut the element.
// //document.querySelector(".script-main").addEventListener("mousedown", doCut, false);
//
// //If the mouse is lifted, tell the program that we're no long dragging the mouse.
// $(".script-main").mouseup(function(elements){
//     lift(elements);
// });
// //document.querySelector(".script-main").addEventListener("mouseup", lift, false);
//
// //Stop cutting or uncutting if the mouse leaves the document or window.
// $(document).mouseleave(function()
// {
//     lift();
// });
//
// $(".toggle-button").click(toggleScript);
// $(".save-button").click(saveWrapper);
// //document.querySelector(".save-button").addEventListener("click", saveWrapper, false);
// var mousedrag = false;
// var origId = 0;
// var cutlist = [];
// var uncutlist = [];
// var checkId = "";
// var compressed = false;
//
//
// $(window).on("beforeunload", function() {
//     if(cutlist.length != 0 || uncutlist != 0)
//     {
//         return "Are you sure you want to leave? You have unsaved work which will be lost.";
//     }
// });
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
//   if(cutlist.length > 0 || uncutlist.length > 0){
//     var modal3 = document.getElementById("save-modal");
//     modal3.style.display = "block";
//     saveCut();
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
//       var modal3 = document.getElementById("save-modal");
//       modal3.style.display = "none";
//       window.alert("Saved!");
//       return;
//     }
//
//     if(cutlist.length != 0)
//     {
//         idNum = cutlist.pop();
//         var cutmessage = "Cut: " + idNum.toString();
//         console.log(cutmessage);
//         $.post("/cuts/new",
//         {
//             editI: cEditId,
//             wordI: idNum
//         },function()
//         {
//             saveCut();
//         });
//         return;
//     }
//     if(uncutlist.length != 0)
//     {
//         idNum = uncutlist.pop();
//         var cutmessage = "Uncut: " + idNum.toString();
//         console.log(cutmessage);
//         $.post("/cuts/delete",
//         {
//             editI: cEditId,
//             wordI: idNum
//         },function()
//         {
//             saveCut();
//         });
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
//           style = "line-through";
//           if(clickedItem.getAttribute("class") == "cword" || clickedItem.getAttribute("class") == "cstage")
//           {
//               color = "#D3D3D3";
//           }
//           else
//           {
//               color = "#888888";
//           }
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
//       currObj = document.getElementById(origId.toString());
//       modifyStyle(currObj,color,style,cut);
//       dataCut(currObj,cut);
//       console.log("cutting word with id " + origId);
//       origId++;
//     }
// }
//
// // all words will need to be printed within the div class "script-main"
// function doCut(e) {
//     console.log(e);
//     var clickedItem = e;
//     // Strikesthrough lines if mouse is down, and unstrikes if shift is also held.
//     if (clickedItem.attr('class') == "word" || clickedItem.attr('class') == "punc" || clickedItem.attr('class') == "cword" || clickedItem.attr('class') == "stage" || clickedItem.attr('class') == "cstage")
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
//             {
//                 $(".script-main").hide();
//                 $(".script-second").show();
//             });
//     }
//     compressed = !compressed;
// }