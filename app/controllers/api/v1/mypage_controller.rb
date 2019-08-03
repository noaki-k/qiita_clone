class Api::V1::MypageController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    articles = current_user.articles.order(updated_at: :desc)
    render json: articles
  end
end
