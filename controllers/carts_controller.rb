class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end


  # GET /carts/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Giỏ hàng đã được lưu.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end
    
    def invalid_cart
      redirect_to root_path, notice: 'Giỏ hàng không hợp lệ.'
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end
end
