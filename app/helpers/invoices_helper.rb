module InvoicesHelper
  def tax_category_options
    options = []
    @tax_categories.each do |tax|
      options << [tax.name, tax.id]
    end
    return options
  end

  def tax_category_val(id)
    puts ">>>>>>>"
    puts id
    @tax_categories.find(id)
  end

  def invoice_limit_options
    options = [
      [10000000, 10000000],
      [1000000, 1000000],
      [100000, 100000],
      [10000, 10000],
    ]
  end

  def cess_options
    options = [
      ["17%", 0.17],
      ["16%", 0.16],
      ["13%", 0.13],
      ["11%", 0.11],
      ["10%", 0.1],
      ["6%", 0.06],
      ["5%", 0.05],
      ["3%", 0.03],
      ["0%", 0]
    ]
  end
end
