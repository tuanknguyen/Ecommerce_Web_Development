class MoreImagesController < ApplicationController
    before_action :authorize
    before_action :set_product
    
    include CurrentRole
    before_action :check_role_admin , only: [:index,:show, :edit, :update, :destroy]
    
    include CurrentUser
    before_action :set_user , only: [:index]
    
    def destroy
      remain_images = remove_image_at_index(params[:id].to_i)
      if remain_images.empty?
        @product.update_column(:more_images, remain_images)
      else
        @product.update_attribute(:more_images, remain_images)
      end
      respond_to do |format|
        format.js   { render partial: "destroy_more_image"}
      end
    end
  
    private
      def set_product
          @product = Product.find(params[:product_id])
      
      def remove_image_at_index(index)
          remain_images = @product.more_images # copy the array
          deleted_image = remain_images.delete_at(index) # delete the target image
          # deleted_image.try(:remove!) # delete image from S3
          return remain_images # re-assign back
      end
      
      def images_params
        params.require(:product).permit({more_images: []}) # allow nested params as array
      end
    end
        
end
