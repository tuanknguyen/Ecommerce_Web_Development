class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  
  include CurrentRole
  before_action :check_role_admin , only: [:index,:show, :edit, :update, :destroy]
  
  include CurrentUser
  before_action :set_user , only: [:index]
  
  # GET /products
  # GET /products.json
  def index
    @user = User.find(session[:user_id])
    # superadmin can view all products
    if @user.roles_mask == 3
      @products = Product.where(active: true)
    else
      @products = Product.where(admin_id: @user.id, active: true)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.admin_id = session[:user_id]
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Sản phẩm đã được tạo thành công.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product.admin_id = session[:user_id]
    add_images(product_params[:more_images])
    new_product_params = product_params
    new_product_params.delete(:more_images)
    respond_to do |format|
      if @product.update(new_product_params)
        format.html { redirect_to products_path, notice: 'Sản phẩm đã được lưu thành công.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # Xoa san pham
  def make_inactive
    @product = Product.find_by_id(params[:id])
    @product.active = false
    if @product.save
      redirect_to products_path, notice: 'Sản phẩm đã được xóa thành công.'
    else
      redirect_to products_path, alert: 'Sản phẩm không xóa được.'
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Sản phẩm đã được xóa thành công.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :image_url,:price, :quantity, :description, :origin, :ratings, :material, :ngmau, :washing_guide, :size_guide, :discount, more_images: [], category_ids: [], subproducts_attributes: [:id, :color, :size, :quantity, :_destroy])
    end
    
    def add_images(new_images)
      if new_images
        @product.more_images += new_images
      end
    end
end
