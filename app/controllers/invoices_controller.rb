require "rexml/document" 
require "builder"

class InvoicesController < ApplicationController
  layout "application_control"
  before_action :authenticate_user!
  load_and_authorize_resource
  authorize_resource :except => [:export_xml]

  before_action :get_buyer

  def index
    @invoices = @buyer.invoices.all
    gon.buyer = @buyer.id
  end

  def new
    @invoice = Invoice.new
    @tax_categories = TaxCategory.all
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.buyer = @buyer
    @tax_category = TaxCategory.find(tax_category_params[:tax_category_id])
    @invoice.tax_category = @tax_category
    if @invoice.save
      redirect_to buyer_invoice_url(@buyer, @invoice)
    else
      render :new
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @tax_categories = TaxCategory.all
  end

  def update
    @tax_category = TaxCategory.find(tax_category_params[:tax_category_id])
    @invoice = Invoice.find(params[:id])
    @invoice.tax_category = @tax_category
    if @invoice.update(invoice_params)
      redirect_to buyer_invoice_path(@buyer, @invoice)
    else
      render :edit
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to :action => :index
  end

  def batch
  end

  def batch_add
    names = params[:invoice][:name].split(/\r\n/)
    standards = params[:invoice][:standard].split(/\r\n/)
    units = params[:invoice][:unit].split(/\r\n/)
    amounts = params[:invoice][:amount].split(/\r\n/)
    prices = params[:invoice][:tax_unit_price].split(/\r\n/)
    cess = 0.03
    size = [names.size, standards.size, units.size, amounts.size, prices.size].max

    size.times do |i|
      name = names[i].blank? ? "" : names[i]
      standard = standards[i].blank? ? "" : standards[i]
      unit = units[i].blank? ? "" : units[i]
      amount = amounts[i]
      price = prices[i]

      if name.blank? and standard.blank? and unit.blank? and amount.blank? and price.blank?
        next
      else
        amount = amount.to_f
        tax_unit_price = price.to_f

        tax_total = fromat_number(amount*tax_unit_price, 0)
        untax_unit_price = fromat_number(tax_unit_price/(1+cess), 10)
        untax_total = fromat_number(tax_total/(1+cess), 2)
        tax_money = fromat_number(untax_total*cess, 2)

        category = TaxCategory.find_by_name(name.strip)

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
          :buyer => @buyer 
        )
      end
    end

    redirect_to buyer_invoices_path(@buyer) 
  end

  def export_xml
    system = SystemInfo.first
    xml_str = ""
    xml = Builder::XmlMarkup.new(:target=>xml_str, :indent=>2)
    xml.instruct!
    xml.kp {
      xml.Version(system.version)
      xml.Fpxx {
        xml.Zsl(1)
        xml.Fpsj {
          xml.Fp {
            xml.Djh(1)
            xml.Gfmc(@buyer.name)
            xml.Gfsh(@buyer.duty_paragraph)
            xml.Gfyhzh(@buyer.account)
            xml.Gfdzdh(@buyer.phone)
            xml.Bz(@buyer.remark)
            xml.Fhr(@buyer.checker)
            xml.Skr(@buyer.payee)
            xml.Spbmbbh(system.tax_category_version)
            xml.Hsbz(0)
            xml.Sgbz(0)

            xml.Spxx {
              ids = params[:invoice_number]
              invoices = Invoice.find(ids)
              invoices.each_with_index do |i, index|
                xml.Sph {
                  xml.Xh(index + 1)
                  xml.Spbm(i.tax_category.code)
                  xml.Qyspbm()
                  xml.Syyhzcbz(0)
                  xml.Yhzcsm()
                  xml.Lslbz()

                  xml.Spmc(i.tax_category.name)
                  xml.Ggxh(i.standard)
                  xml.Jldw(i.unit)
                  xml.Dj(i.tax_unit_price)
                  xml.Sl(i.amount)
                  xml.Je(i.tax_total)
                  xml.Slv(i.cess)
                  xml.Se(i.tax_money)
                  xml.Kce(0)
                }
              end
            }
          }
        }
      }
    }
  
    template_dir = File.join(Rails.root, "public", "template")
    Dir::mkdir(template_dir) unless File.directory?(template_dir)
    target_xml = File.join(Rails.root, "public", "template", @buyer.name + '发票模板.xml') 
    File.open(target_xml, "w+") do |file|
      file.write xml_str
    end

    send_file target_xml, :filename => @buyer.name + '发票模板.xml', :type => "application/force-download", :x_sendfile=>true
  end

  private

    def get_buyer 
      @buyer = Buyer.find(params[:buyer_id])
    end

    def invoice_params
      params.require(:invoice).permit(:standard, :unit, :amount, :tax_unit_price, :tax_total, :cess, :tax_money, :tax_category_attributes, :untax_unit_price, :untax_total)
    end

    def tax_category_params
      params.require(:invoice).permit(:tax_category_id)
    end

    def fromat_number(number, decimal)
      result = format("%." + decimal.to_s + "f", number)
      result.to_f
    end
end

