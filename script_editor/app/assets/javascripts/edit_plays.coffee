## Place all the behaviors and hooks related to the matching controller here.
## All this logic will automatically be available in application.js.
## You can use CoffeeScript in this file: http://coffeescript.org/
##Create events for the various functions associated with strikethrough.
##If we click the mouse down, tell the program we're dragging the mouse.
##Save that the mouse is down.
#


#drag = (e) ->
#  mousedrag = true
#  origId = parseInt(e.target.id)
#  return
#
##Save that the mouse is up.
#
#lift = (e) ->
#  doCut e
#  mousedrag = false
#  return
#
##A filter which removes the word given.
#
#remove = (word) ->
#  word != checkId
#
##Manage the data necessary to cut or uncut a word.
#
#dataCut = (clickedItem, cut) ->
#  idNum = parseInt(clickedItem.id)
#  checkId = idNum
#  if cut
#    cutlist = cutlist.filter(remove)
#    cutlist.push idNum
#  else
#    uncutlist = uncutlist.filter(remove)
#    uncutlist.push idNum
#  return
#
#saveWrapper = ->
#  if cutlist.length > 0 or uncutlist.length > 0
#    modal3 = document.getElementById('save-modal')
#    modal3.style.display = 'block'
#    saveCut()
#  return
#
##If the save button is hit, send cached data to the database.
#
#saveCut = ->
#  `var cutmessage`
#  script = $('.script-main')[0]
#  cEditId = parseInt(script.id)
#  if cutlist.length == 0 and uncutlist.length == 0
#    modal3 = document.getElementById('save-modal')
#    modal3.style.display = 'none'
#    window.alert 'Saved!'
#    return
#  if cutlist.length != 0
#    idNum = cutlist.pop()
#    cutmessage = 'Cut: ' + idNum.toString()
#    console.log cutmessage
#    $.post '/cuts/new', {
#      editI: cEditId
#      wordI: idNum
#    }, ->
#      saveCut()
#      return
#    return
#  if uncutlist.length != 0
#    idNum = uncutlist.pop()
#    cutmessage = 'Uncut: ' + idNum.toString()
#    console.log cutmessage
#    $.post '/cuts/delete', {
#      editI: cEditId
#      wordI: idNum
#    }, ->
#      saveCut()
#      return
#    return
#  return
#
##Changes visuals of a word.
#
#modifyStyle = (clickedItem, color, style, cut) ->
#  clickedItem.style.color = color
#  clickedItem.style.textDecoration = style
#  clickedItem.dataset.cut = cut
#  return
#
##Actually executes the XML cut on a word based on whether it was cut before or not.
#
#literalCut = (clickedItem, cut) ->
#  color = undefined
#  style = undefined
#  currId = parseInt(clickedItem.id)
#  console.log 'ORIG ID: ' + origId
#  console.log 'CURR ID: ' + currId
#  if cut
#    style = 'line-through'
#    if clickedItem.getAttribute('class') == 'cword' or clickedItem.getAttribute('class') == 'cstage'
#      color = '#D3D3D3'
#    else
#      color = '#888888'
#  else
#    style = 'none'
#    if clickedItem.getAttribute('class') == 'cword' or clickedItem.getAttribute('class') == 'cstage'
#      color = '#006BFF'
#    else
#      color = '#000000'
#  while origId <= currId
#    currObj = document.getElementById(origId.toString())
#    modifyStyle currObj, color, style, cut
#    dataCut currObj, cut
#    console.log 'cutting word with id ' + origId
#    origId++
#  return
#
## all words will need to be printed within the div class "script-main"
#
#doCut = (e) ->
#  console.log e
#  clickedItem = e
#  # Strikesthrough lines if mouse is down, and unstrikes if shift is also held.
#  if clickedItem.attr('class') == 'word' or clickedItem.attr('class') == 'punc' or clickedItem.attr('class') == 'cword' or clickedItem.attr('class') == 'stage' or clickedItem.attr('class') == 'cstage'
#    if mousedrag and !e.shiftKey
#      literalCut clickedItem, true
#    else if e.shiftKey and mousedrag
#      literalCut clickedItem, false
#  return
#
#toggleScript = (e) ->
#  if compressed
#    $('.script-second').hide()
#    document.getElementById('toggle-text').textContent = 'HIDE CUTS'
#    $('.script-main').show()
#  else
##Got hide syntax from https://stackoverflow.com/questions/9456289/how-to-make-a-div-visible-and-invisible-with-javascript
#    document.getElementById('toggle-text').textContent = 'SHOW CUTS'
#    location = '/edits/compress/'.concat(window.location.pathname.substring(7, window.location.pathname.length)).concat(' .script-second')
#    $('.script-second').load location, ->
#      $('.script-main').hide()
#      $('.script-second').show()
#      return
#  compressed = !compressed
#  return
#
#$('.script-main').mousedown drag
#console.log document
##If we move the mouse over an element, let it know. If the mouse is down, this will strikethrough the element.
##document.querySelector(".script-main").addEventListener("mouseover", doCut, false);
##If the mouse is clicked down over an element, cut the element.
##document.querySelector(".script-main").addEventListener("mousedown", doCut, false);
##If the mouse is lifted, tell the program that we're no long dragging the mouse.
#$('.script-main').mouseup (elements) ->
#  lift elements
#  return
##document.querySelector(".script-main").addEventListener("mouseup", lift, false);
##Stop cutting or uncutting if the mouse leaves the document or window.
#$(document).mouseleave ->
#  lift()
#  return
#$('.toggle-button').click toggleScript
#$('.save-button').click saveWrapper
##document.querySelector(".save-button").addEventListener("click", saveWrapper, false);
#mousedrag = false
#origId = 0
#cutlist = []
#uncutlist = []
#checkId = ''
#compressed = false
#$(window).on 'beforeunload', ->
#  if cutlist.length != 0 or uncutlist != 0
#    return 'Are you sure you want to leave? You have unsaved work which will be lost.'
#  return
##Credit to Odin Thunder https://stackoverflow.com/questions/45349885/how-to-resend-a-failed-ajax-request-globally
##If a server call fails, try again.
#$(document).ajaxError (event, jqxhr, settings, thrownError) ->
#  console.log settings
#  $.ajax settings
#  return
#
## ---
## generated by js2coffee 2.2.0