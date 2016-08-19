$(document).on('page:change', function(){
  $('.is_correct_answer').on('click', function() {
    $('.is_correct_answer').each(function() {
      $(this).prop("checked", false);
    })
    $(this).prop("checked", true);
  });
});
