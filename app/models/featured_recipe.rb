class FeaturedRecipe < ApplicationRecord
 has_many :comments, dependent: :destroy
end