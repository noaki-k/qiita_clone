module Api::V1
  class ArticlesController < BaseApiController
    before_action :set_article, only: [:show, :update,:destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      articles = Article.published.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      render json: @article
    end

    def update
      @article.update!(article_params)
      render json: @article
    end

    def destroy
      @article.destroy!
    end

    def create
      @article = current_user.articles.create!(article_params)
      render json: @article
    end

    private

    def set_article
      @article = Article.published.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :text, :status)
    end
  end
end
