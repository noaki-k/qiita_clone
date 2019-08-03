module Api::V1
  class MypageController < BaseApiController
    before_action :authenticate_user!, only: [:index]

    def index
      articles = current_user.articles.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::MypageSerializer
    end
  end
end
