# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@hideEditComment = ->
  $('.edit_comment_link').click (event) ->
    event.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId')
    $('form#edit_comment_' + comment_id).show();

$(document).on "turbolinks:load", ->
  hideEditComment();
