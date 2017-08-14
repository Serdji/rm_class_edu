//= require underscore

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require selectize

//= require jquery-ui.min
//= require jquery-ui-sortable.min
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
//= require simplemde

//= require tinymce

//= require admin/crud
//= require admin/webdav
//= require admin/file_upload
//= require admin/datepicker
//= require admin/signin
//= require admin/lists
//= require admin/menu
//= require admin/employees
//= require admin/answers
//= require admin/questions
//= require admin/seoable
//= require admin/validations
//= require admin/flash
//= require admin/grades_subjects_select
//= require admin/users

//= require admin/simplemde
//= require_tree ./textEditor

//= require admin/sections
//= require_tree ./DragDropAuthor

$(function() {
  $('[data-toggle="tooltip"]').tooltip({ container: 'body' });

  $('.collapse-expand').click(function(event) {
    event.preventDefault();
    var parent = $(this).parent();

    $(event.currentTarget).children().removeClass('hidden');
    $(event.target).addClass('hidden');

    parent.find('.expanded').toggleClass('hidden');
    parent.find('.collapsed').toggleClass('hidden');
  });
});
