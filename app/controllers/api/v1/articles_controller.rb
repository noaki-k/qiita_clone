module Api::V1
<<<<<<< HEAD
  class ArticlesController < BaseApiController
    before_action :set_article, only: [:show, :update,:destroy]
=======
  class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :update]
>>>>>>> 8491838... modify some files following the advice 2

    def index
      @articles = Article.all
      render json: @articles
    end

    def show
      render json: @article
    end

    def update
      @article.update!(article_params)
      render json: @article
    end

<<<<<<< HEAD
    def destroy
      @article.destroy!
    end

=======
>>>>>>> 8491838... modify some files following the advice 2
    private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :text)
    end
  end
end
