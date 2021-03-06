$(function() {
  $(document).on('click', '[data-role="dynamic-fields"] > .form-inline [data-role="remove"]', function(e) {
    e.preventDefault();
    $(this).closest('.form-inline').remove();
  }
);
  $(document).on('click', '[data-role="dynamic-fields"] > .form-inline [data-role="add"]',function(e) {
    e.preventDefault();
    var container = $(this).closest('[data-role="dynamic-fields"]');
    new_field_group = container.children().filter('.form-inline:first-child').clone();
    new_field_group.find('input').each(function(){
      $(this).val('');
    });
    container.append(new_field_group);
  });
  $( '.datepicker' ).datepicker({dateFormat: 'dd/mm/yy'});
});
