# app/models/tweet.rb
class Tweet < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
end
