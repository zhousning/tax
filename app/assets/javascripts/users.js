$(".users, .roles, .buyers, .tax_categories, .templates").ready(function(e) {
  var pathMatch = location.pathname.match(/\/(\w+)?[\/]?(\w*)/); 
  var str = ".js-" + pathMatch[1];
  if (pathMatch[2] == "control") {
    str += "-" + pathMatch[2];
  }
  $(str).addClass("active");
})

