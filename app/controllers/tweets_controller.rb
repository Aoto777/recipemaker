class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  def index
    @tweets = Tweet.order(created_at: :desc)

    # 固定レシピ(YAML)
    data = YAML.load_file(Rails.root.join("config/featured_recipes.yml")) rescue {}
    @popular_recipes     = data["popular"]     || []
    @recommended_recipes = data["recommended"] || []
  end

  def show
    @tweet = Tweet.find(params[:id])
    # @tweet は set_tweet 済み
     @comments = @tweet.comments
     @comment = Comment.new
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save
      redirect_to root_path, notice: "投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path, notice: "削除しました。"
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:title, :recipe, :material, :time, :comment, :image, :overall, :level, :servings)
  end
end
