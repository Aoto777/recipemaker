# app/controllers/featured_recipes_controller.rb
require "yaml"
require "ostruct"

class FeaturedRecipesController < ApplicationController
  def show
    data = YAML.load_file(Rails.root.join("config/featured_recipes.yml")) rescue {}
    all  = (data["popular"] || []) + (data["recommended"] || [])
    h    = all.find { |r| r["slug"] == params[:slug] }
    redirect_to root_path, alert: "レシピが見つかりません" and return unless h

    @recipe = OpenStruct.new(
      title:       h["title"],
      time:        h["time"],
      overall:     h["overall"],
      level:       h["level"],
      comment:     h["comment"],
      material:    h["material"],
      recipe:      h["recipe"],
      image_asset: h["image_asset"],   # ← ここ！
      image_url:   h["image_url"]      # URLで管理してる項目があれば任意
      
    )
  end
end
