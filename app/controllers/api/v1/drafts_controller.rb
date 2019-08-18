module Api::V1
  class DraftsController < BaseApiController
    before_action :authenticate_user!, only: [:index, :show]
    before_action :set_article, only: [:show]

    def index
      articles = current_user.articles.draft.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      render json: @article, each_serializer: Api::V1::ArticleSerializer
    end

    def set_article
      @article = current_user.articles.draft.find(params[:id])
    end
  end
end
