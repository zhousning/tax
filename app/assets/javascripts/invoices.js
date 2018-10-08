$(".invoices.new, .invoices.edit").ready(function() {
  $(".js-amount, .js-tax-unit-price").keyup(function() {
    write_money_result();
  });

  $(".js-cess").change(function() {
    write_money_result();
  });

  $(".invoice-tax-item").click(function() {
    var that = this;
    var id = $(that).attr("data-id");
    var name = $.trim($(that).text());
    $("#invoice_tax_category_id").attr("value", id); 
    $("#tax_category").attr("value", name);
  });
  
  $(".js-tax-category-val").keyup(function() {
    var that = this;
    var categoryVal = $.trim($(that).val().toLowerCase());
    var ulCtn = $(".invoice-tax-category-ctn ul"); 
    var items = $(".invoice-tax-category-ctn .invoice-tax-item"); 
    items.each(function(i, item) {
      var itemText = $(item).text().toLowerCase();
      if (itemText.indexOf(categoryVal) != -1) {
        $(".without-option").remove();
        items.eq(i).show();
      } else {
        items.eq(i).hide();
      }
    });
    if ($(".invoice-tax-item[style*='none']").length == 0) {
      ulCtn.append('<li class="list-group-item without-option"><a href="/tax_categories">没有该商品编码，请先添加</a></li>');
    }
  });
});

$(".invoices.index").ready(function() {
  tax_count();
  $(".js-index-cess").change(function() {
    var that = this;
    var cess_val = $(that).val(); 
    $(".invoice-body-tr").each(function() {
      var cess = $(this).find(".invoice-index-cess");
      var amount = $(this).find(".invoice-index-amount");
      var price = $(this).find(".invoice-index-price");

      var result = money_calculator(parseFloat(price.text()), parseFloat(amount.text()), parseFloat(cess_val))

      var unprice = $(this).find(".invoice-index-unprice");
      var untotal = $(this).find(".invoice-index-untotal");
      var money = $(this).find(".invoice-index-money");

      cess.text(cess_val*100 + "%");
      unprice.text(result.price.toString());
      untotal.text(result.total);
      money.text(result.money);
    });
    tax_count();
  });

  $(".invoice-number").click(function() {
    var count = 0;
    var my = this;
    var limit = $(".js-invoice-limit").val();
    $(".invoice-number:checked").each(function() {
      var that = this;
      var total = $(that).parentsUntil(".invoice-body").find(".invoice-index-total").text();
      count += parseFloat(total);
    });
    if (count > parseFloat(limit)) {
      $(my).prop("checked", false);
      alert("已超出发票限额");
    }
    if ($(".invoice-number:checked").length == 0) {
      $(".js-export-xml").prop("disabled", true);
    } else {
      $(".js-export-xml").prop("disabled", false);
    }
  });

  $("input[name='invoice-all']").click(function() {
    var my = this;
    if ($(my).is(":checked")) {
      var count = 0;
      var limit = $(".js-invoice-limit").val();
      var numbers = $(".invoice-number");
      numbers.prop("checked", false);
      for (var i=0; i<numbers.length; i++) {
        var that = numbers[i];
        var total = $(that).parentsUntil(".invoice-body").find(".invoice-index-total").text(); 
        count += parseFloat(total);
        if (count > parseFloat(limit)) {
          if (i == 0) {
            $(".js-export-xml").prop("disabled", true);
            $(my).prop("checked", false);
          } else {
            $(".js-export-xml").prop("disabled", false);
          }
          alert("已超出发票限额");
          break;
        } else {
          $(".js-export-xml").prop("disabled", false);
          numbers.prop("checked", true);
        }
      }
    } else {
      $(".js-export-xml").prop("disabled", true);
      $(".invoice-number").prop("checked", false);
    }
  });

  $(".js-invoice-limit").click(function() {
    var count = 0;
    var limit = $(".js-invoice-limit").val();
    var numbers = $(".invoice-number:checked");
    if (numbers.length !=0) {
      numbers.each(function() {
        var that = this;
        var total = $(that).parentsUntil(".invoice-body").find(".invoice-index-total").text();
        count += parseFloat(total);
      });
      if (count > parseFloat(limit)) {
        $(".js-export-xml").prop("disabled", true);
        alert("已超出发票限额");
      } else {
        $(".js-export-xml").prop("disabled", false);
      }
    } else {
      $(".js-export-xml").prop("disabled", true);
    }
  });
});

function tax_count() {
  var untax_count = 0;
  var intax_count = 0;
  var tax_count = 0;
  $(".invoice-body-tr").each(function() {
    var total = $(this).find(".invoice-index-total");
    var untotal = $(this).find(".invoice-index-untotal");
    var money = $(this).find(".invoice-index-money");

    untax_count += parseFloat(total.text());
    intax_count += parseFloat(untotal.text());
    tax_count += parseFloat(money.text());
  });
  $(".untax-count").html(untax_count.toFixed(2) + "&nbsp;&nbsp;&nbsp;");
  $(".intax-count").html(intax_count.toFixed(2) + "&nbsp;&nbsp;&nbsp;");
  $(".tax-count").html(tax_count.toFixed(2));
}
function write_money_result() {
  var cess = $(".js-cess").val(); 
  var amount = $(".js-amount").val();
  var price = $(".js-tax-unit-price").val();

  var total = (parseFloat(amount)*parseFloat(price)).toFixed(0);
  var result = money_calculator(parseFloat(price), parseFloat(amount), parseFloat(cess))

  $(".js-tax-total").val(total);
  $(".js-untax-unit-price").val(result.price);
  $(".js-untax-total").val(result.total);
  $(".js-tax-money").val(result.money);
}

function money_calculator(tax_unit_price, amount, cess) {
  var untax_unit_price = (tax_unit_price/(1+cess)).toFixed(10);
  var untax_total = ((amount*tax_unit_price)/(1+cess)).toFixed(2);
  var tax_money = (untax_total*cess).toFixed(2);
  var result = {
    price: untax_unit_price,
    total: untax_total,
    money: tax_money
  }
  return result;
}
