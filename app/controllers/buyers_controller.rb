class BuyersController < ApplicationController
  before_action :authenticate_user!

  def index
    @buyers = current_user.buyers.all
  end

  def show
    @buyer = Buyer.find(params[:id])
  end

  def new
    @buyer = Buyer.new
  end

  def edit
    @buyer = Buyer.find(params[:id])
  end

  def update
    @buyer = Buyer.find(params[:id])
    if @buyer.update(buyer_params)
      redirect_to buyer_path(@buyer) 
    else
      render :edit
    end
  end

  def create
    @buyer = Buyer.new(buyer_params)
    @buyer.user = current_user
    if @buyer.save
      redirect_to @buyer
    else
      render :new
    end
  end

  def destroy
    @buyer = Buyer.find(params[:id])
    @buyer.destroy
    redirect_to :action => :index
  end


  private

    def buyer_params
      params.require(:buyer).permit(:alias, :name, :duty_paragraph, :account, :phone)
    end
end

