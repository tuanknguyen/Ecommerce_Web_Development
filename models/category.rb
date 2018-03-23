class Category < ActiveRecord::Base
	has_many :tags, :dependent => :destroy
	has_many :products, through: :tags

	validates :name, length: {maximum: 50}, presence: true, uniqueness: { case_sensitive: false}
end
