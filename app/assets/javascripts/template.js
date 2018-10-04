$(".templates.index").ready(function() {
  $("#fake-file-button-browse").click(function() {
    $("#files-input-upload").click();
  });

  $("#files-input-upload").change(function() {
    var that = this;
    $('#fake-file-input-name').val($(that).val());
    $('#fake-file-button-upload').removeAttr('disabled');
  });

  $('#fake-file-button-upload').click(function() {
    $(".template-ctn").css("display", "none");
    $(".template-loading").css("display", "block");
    var form = new FormData(document.getElementById('my-form'));

    $.ajax({
      url: "/templates/parse_template",
      type: "POST",
      data: form,
      dataType: "json",
      processData: false,  // 不处理数据
      contentType: false,  
      success: function(data) {
        if (data.result == "error") {
          $(".template-loading").css("display", "none");
          $(".parse-error").css("display", "block");
        } else {
          window.location = "/buyers"
        }
      }
    });
  });

});
