$(".invoices.edit, .invoices.edit").ready(function() {
  $(".js-amount, .js-tax-unit-price").keyup(function() {
    write_money_result();
  });

  $(".js-cess").change(function() {
    write_money_result();
  });
})

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
