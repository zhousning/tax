require "rexml/document" 

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
    file = File.new(File.join(Rails.root, "public", 'test.xml'),"w+")
    doc = REXML::Document.new
    kp = doc.add_element ('Kp')
    version = kp.add_element( 'Version')
    version.add_text "2.0"
    fpxx = kp.add_element('Fpxx')
    zsl = fpxx.add_element('Zsl')
    zsl.add_text "1"
    fpsj = fpxx.add_element('Fpsj')
    fp = fpsj.add_element('Fp')
    djh = fp.add_element('Djh')
    djh.add_text '1'
    gfmc = fp.add_element('Gfmc')
    gfmc.add_text '祈祷'
    gfsh = fp.add_element('Gfsh')
    gfyhzh = fp.add_element('Gfyhzh')
    gfdzdh = fp.add_element('Gfdzdh')
    bz = fp.add_element('Bz')
    fhr = fp.add_element('Fhr')
    skr = fp.add_element('Skr')
    spbmbbh = fp.add_element('Spbmbbh')
    spbmbbh.add_text '30.0'
    hsbz = fp.add_element('Hsbz')
    hsbz.add_text '30.0'
    sgbz = fp.add_element('Sgbz')
    sgbz.add_text '30.0'
    spxx = fp.add_element('Spxx')

    @invoices = Invoice.all
    @invoices.each do |i|
      sph = spxx.add_element('Sph')
      xh = sph.add_element('Xh')
      xh.add_text '1'
      spbm = sph.add_element('Spbm')
      spbm.add_text '3333333'
      qyspbm = sph.add_element('Qyspbm')
      syyhzcbz = sph.add_element('Syyhzcbz')
      syyhzcbz = syyhzcbz.add_text '3333'
      yhzcsm = sph.add_element('Yhzcsm')
      lslbz = sph.add_element('Lslbz')

      spmc = sph.add_element('Spmc')
      spmc.add_text'缸套' 
      ggxh = sph.add_element('Ggxh')
      jldw = sph.add_element('Jldw')
      jldw.add_text i.unit
      dj = sph.add_element('Dj')
      dj.add_text i.tax_unit_price
      sl = sph.add_element('Sl')
      sl.add_text i.amount
      je = sph.add_element('Je')
      je.add_text i.tax_total
      slv = sph.add_element('Slv')
      slv.add_text i.cess
      se = sph.add_element('Se')
      se.add_text i.tax_money
      kce = sph.add_element('Kce')
      kce.add_text '0'
    end

    File.open(File.join(Rails.root, "public", 'test2.xml'),"w+") do |file|
      file.write doc
    end

    send_file File.join(Rails.root, "public", 'test2.xml'), :filename => "test.xml", :type => "application/force-download", :x_sendfile=>true
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

