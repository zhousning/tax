class TaxCategoriesController < ApplicationController
  layout "application_control"
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @tax_categories = current_user.tax_categories.all
  end

  def show
    @tax_category = TaxCategory.find(params[:id])
  end

  def new
    @tax_category = TaxCategory.new
  end

  def edit
    @tax_category = TaxCategory.find(params[:id])
  end

  def update
    @tax_category = TaxCategory.find(params[:id])
    if @tax_category.update(tax_category_params)
      redirect_to tax_category_path(@tax_category) 
    else
      render :edit
    end
  end

  def create
    @tax_category = TaxCategory.new(tax_category_params)
    @tax_category.user = current_user
    if @tax_category.save
      redirect_to @tax_category
    else
      render :new
    end
  end

  def destroy
    @tax_category = TaxCategory.find(params[:id])
    @tax_category.destroy
    redirect_to :action => :index
  end

  private

    def tax_category_params
      params.require(:tax_category).permit(:name, :code)
    end
end

