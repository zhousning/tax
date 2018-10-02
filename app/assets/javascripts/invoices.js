$().ready(function() {
  $(".js-amount, .js-tax-unit-price").keyup(function() {
    var amount = $(".js-amount").val();
    var cess = $(".js-cess").val(); 
    var price = $(".js-tax-unit-price").val();
    var total = parseFloat(amount)*parseFloat(price);
    $(".js-tax-total").val(total);

    money_calculator(parseFloat(price), parseFloat(amount), parseFloat(cess))
  });

  $(".js-cess").change(function() {
    var that = this;
    var cess = $(that).val(); 
    var amount = $(".js-amount").val();
    var price = $(".js-tax-unit-price").val();
    money_calculator(parseFloat(price), parseFloat(amount), parseFloat(cess))
  });
})

function money_calculator(tax_unit_price, amount, cess) {
  var untax_unit_price = tax_unit_price/(1+cess);
  var untax_total = ((amount*tax_unit_price)/(1+cess)).toFixed(2);
  var tax_money = (untax_total*cess).toFixed(2);
  $(".js-untax-unit-price").val(untax_unit_price);
  $(".js-untax-total").val(untax_total);
  $(".js-tax-money").val(tax_money);
}
