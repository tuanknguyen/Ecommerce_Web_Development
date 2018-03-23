class StoreController < ApplicationController
  def index
  	@products = Product.where(active: true).order("RANDOM()").paginate(:page => params[:page], :per_page => 15)
    # search by category
    if params[:cat]
      @products = Product.includes(:category).where('categories.id' => params[:cat]).where(active: true).order("RANDOM()").paginate(:page => params[:page], :per_page => 15)
    else
      @products = Product.where(active: true).order("RANDOM()").paginate(:page => params[:page], :per_page => 15)
    end
  end
  
  def detail
    @product = Product.find(params[:id])
		@subproducts = @product.subproducts
		@sizes = @subproducts.pluck(:size).uniq
		@subproduct = nil           # if doesnt work then @subproduct = @subproducts.first
		if params[:size_chosen].blank?
			@colors = []
		else
			@colors = @subproducts.where('size = ?', params[:size_chosen]).pluck(:color)
			respond_to do |format|
 				format.js do
					render :partial => 'size_chosen'
				end
  		end
		end
    # Toi da 5 san pham lien quan duoc chon bang random (khong tinh san pham dang duoc display)
    @suggested_products = Product.where(active: true).where.not(id: @product.id).order("RANDOM()").limit(5)
  end

end
