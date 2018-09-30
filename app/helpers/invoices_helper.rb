module InvoicesHelper
  def tax_category_options
    options = []
    @tax_categories.each do |tax|
      options << [tax.name, tax.id]
    end
    return options
  end
end
