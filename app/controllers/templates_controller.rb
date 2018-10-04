class TemplatesController < ApplicationController
  layout "application_control"
  before_action :authenticate_user!

  def index
  end

  def download
    send_file File.join(Rails.root, "public", "template", "public", "发票数据模板.xlsm"), :filename => "发票数据模板.xlsm", :type => "application/force-download", :x_sendfile=>true
  end

  def parse_template
    flag = true
    begin
      file = params[:category_file]
      creek = Creek::Book.new file.path
      category_sheet = creek.sheets[1]
      invoice_sheet = creek.sheets[0]
      #category_sheet.rows.each do |row|
      #  puts row
      #end
      parse_tax_categories(category_sheet)
      parse_invoices(invoice_sheet)
    rescue Exception => e
      puts e
      flag = false
    end

    if flag
      respond_to do |f|
        f.json {
          render :json => {:result => "success"}
        }
      end
    else
      respond_to do |f|
        f.json {
          render :json => {:result => "error"}
        }
      end
    end
  end

  def parse_tax_categories(sheet)
    sheet.rows.each_with_index do |row, i|
      if i> 0
        index = (i + 1).to_s 
        code = row["B" + index].to_s
        name = row["A" + index].to_s

        if code.blank? and name.blank?
          break
        end

        category = TaxCategory.where(["code = ? ", code]).first
        unless category
          TaxCategory.create(:code => code, :name => name, :user => current_user)
        end
      end
    end
  end

  def parse_invoices(sheet)
    buyer = Buyer.create( :alias => "xx", :name => "xxx", :duty_paragraph => rand(99999), :user => current_user ) 
    begin
      sheet.rows.each_with_index do |row, i|
        if i> 2
          index = (i + 1).to_s
          code = row["J" + index].to_s
          name = row["K" + index].to_s
          standard = row["L" + index].to_s
          unit = row["M" + index].to_s
          amount = row["N" + index]
          tax_unit_price = row["O" + index]
          cess = row["Q" + index].to_f

          if code.blank? and name.blank? and standard.blank? and unit.blank? and amount.blank? and tax_unit_price.blank?
            break
          end

          amount = amount.to_f
          tax_unit_price = tax_unit_price.to_f

          tax_total = fromat_number(amount*tax_unit_price, 0)
          untax_unit_price = fromat_number(tax_unit_price/(1+cess), 10)
          untax_total = fromat_number(tax_total/(1+cess), 2)
          tax_money = fromat_number(untax_total*cess, 2)

          category = TaxCategory.where(["code = ? and name =?", code, name]).first
          unless category
            category = TaxCategory.create(:code => code, :name => name, :user => current_user)
          end

          Invoice.create(
            :standard => standard,
            :unit => unit,
            :amount => amount,
            :tax_unit_price => tax_unit_price,
            :cess => cess,
            :tax_total => tax_total,
            :untax_total => untax_total,
            :untax_unit_price => untax_unit_price,
            :tax_money => tax_money,
            :tax_category => category,
            :buyer => buyer
          )
        end
      end
    rescue Exception => e
      raise e
      buyer.destroy
    end
  end

  private
    def fromat_number(number, decimal)
      result = format("%." + decimal.to_s + "f", number)
      result.to_f
    end
end

#  def parse_buyers(sheet)
#    sheet.simple_rows.each do |row|
#      buyer_alias = row["A"]
#      name = row["B"]
#      duty_paragraph = row["C"]
#      account = row["D"]
#      phone  = row["E"]
#      buyer = Buyer.where(["alias = ? and name = ? and duty_paragraph = ? and account = ? and phone",
#                            buyer_alias,
#                            name,
#                            duty_paragraph,
#                            account,
#                            phone,
#                          ]).first
#
#      unless buyer 
#        Buyer.create(:alias => buyer_alias, :name => name, :duty_paragraph => duty_paragraph, :account => account, :phone => phone)
#      end
#    end
#  end

