class SearchController < ApplicationController
	def search_price
		@products ||= find_products_price
		# @products ||= find_products_sort
		@products = @products.order(created_at: :desc) if (params[:sort_by].to_i == 1 && params[:sort].to_i == 1)
  		@products = @products.order(created_at: :asc) if (params[:sort_by].to_i == 1 && params[:sort].to_i == 2)
  		@products = @products.order(price: :desc) if (params[:sort_by].to_i == 2 && params[:sort].to_i == 1)
  		@products = @products.order(price: :asc) if (params[:sort_by].to_i == 2 && params[:sort].to_i == 2)
  		@products = @products.order(rating: :desc) if (params[:sort_by].to_i == 3 && params[:sort].to_i == 1)
  		@products = @products.order(rating: :asc) if (params[:sort_by].to_i == 3 && params[:sort].to_i == 2)
  		@products = @products.where(category_id: params[:category]) if params[:category].present?
  		
  		if params[:sort_by].blank? || params[:sort].blank?
  			redirect_to root_path
  		end
  	end

	private
		def find_products_price
			
			search_price = Product.where("price >= ?", params[:min]) if params[:min].present?
			search_price = Product.where("price <= ?", params[:max]).where("price >= ?", params[:min]) if params[:max].present?
			search_price

		end
end
