module InvoicesHelper
  def tax_category_options
    options = []
    @tax_categories.each do |tax|
      options << [tax.name, tax.id]
    end
    return options
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
