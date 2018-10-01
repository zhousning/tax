require "rexml/document" 
require "builder"

class InvoicesController < ApplicationController
  before_action :authenticate_user!, :get_buyer

  def index
    @invoices = @buyer.invoices.all
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

  def export_xml
    xml_str = ""
    xml = Builder::XmlMarkup.new(:target=>xml_str, :indent=>2)
    xml.instruct!
    xml.kp {
      xml.Version('2.0')
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
            xml.Spbmbh(30.0)
            xml.Hsbz(0)
            xml.Sgbz(0)

            xml.Spxx {
              @buyer.invoices.each_with_index do |i, index|
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
      params.require(:invoice).permit(:standard, :unit, :amount, :tax_unit_price, :tax_total, :cess, :tax_money, :tax_category_attributes)
    end

    def tax_category_params
      params.require(:invoice).permit(:tax_category_id)
    end
end

