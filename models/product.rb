class Product < ActiveRecord::Base
  has_many :subproducts, dependent: :destroy
  has_many :tags
  has_many :category, through: :tags
  
  validates :ratings , :numericality => {greater_than_or_equal_to: 1 , less_than_or_equal_to: 5}
  validates :title, length: {:in => 3..100 }, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 1000}, presence: true
  validates :discount, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true
  validates :description, length: {:in => 30..2000 }, presence: true

  validates :origin, :material, :ngmau, :washing_guide, :size_guide, length: {maximum: 1000}
  
  # for subproduct
  accepts_nested_attributes_for :subproducts, reject_if: :all_blank, allow_destroy: true
  # end subproduct
  
  SORT = [ "Desc", "Asc" ]
  mount_uploader :image_url, AttachmentUploader
  mount_uploaders :more_images, AttachmentUploader
  
  # search for category (not working)
  # scope :in_category, -> (cats) { includes(:category).where :category_ids => cats }
  # def self.search(search)
  #   if se arch
  #     where("title LIKE ?", "%#{search}%") 
  #   else
  #     find(:all)
  #   end
  # end
end
