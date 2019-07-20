require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  # index method
  describe 'GET /articles' do
    subject { get(api_v1_articles_path) }
    before do
      #PR#38FactoryBotの修正により記述を簡潔に
      create_list(:article, 3)
    end
    it 'articleの一覧が取得できる' do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      #PR#38　article.rbの変更に伴いcomment=>commentsに修正
      expect(res[0].keys).to eq ["id", "title", "text", "user", "article_likes", "comments"]
      #PR#38 userのkeyに関するテストを追加
      expect(res[0]['user'].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(200)
    end
  end

  #show method
  describe 'GET /articles/:id' do
    subject { get(api_v1_articles_path(article_id)) }

    context '指定した id のarticleが存在する場合' do
      #PR#38FactoryBotの修正により記述を簡潔に
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it 'articleの値が取得できる' do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res[0]['id']).to eq article.id
        expect(res[0]['title']).to eq article.title
        expect(res[0]['text']).to eq article.text
        expect(res[0]['user']['id']).to eq article.user.id
        expect(res[0]['user'].keys).to eq ['id', 'name', 'email']
      end
    end

    # context '指定した id のarticleが存在しない場合' do
    #   # PR#38：article_idを必ず存在しない番号にするためにnnp
    #   # 本来は9999をArticle.last.id + 1と書いた方がベター
    #   let(:article_id) { 9999 }
    #   it 'articleが見つからない' do

    #   expect { subject }. to raise_error ActiveRecord::RecordNotFound
    #   end
    # end
  end
end
