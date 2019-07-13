require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  # index method
  describe 'GET /articles' do
    subject { get(articles_path) }
    before do
      user = FactoryBot.create(:user)
      create_list(:article, 3, user: user)
    end
    it 'articleの一覧が取得できる' do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "text", "user", "article_likes", "comment"]
      expect(response).to have_http_status(200)
    end
  end

  #show method
  describe 'GET /articles/:id' do
    subject { get(article_path(article_id)) }

    context '指定した id のarticleが存在する場合' do
      let(:user) { FactoryBot.create(:user) }
      let(:article) { FactoryBot.create(:article, user: user) }
      let(:article_id) { article.id }

      it 'articleの値が取得できる' do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res['title']).to eq article.title
        expect(res['text']).to eq article.text
      end
    end

    context '指定した id のarticleが存在しない場合' do
      let(:article_id) { 99999 }
      it 'articleが見つからない' do
        expect { subject }. to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  #update method
  describe 'PUTCH /articles/:id' do
    subject { patch(article_path(article.id), params: params) }
    let(:params) { { article: { title: Faker::Book.title, created_at: Time.current } } }
    let(:user) { FactoryBot.create(:user) }
    let(:article) { FactoryBot.create(:article, user: user) }

    it '指定したarticleのレコードが更新される' do
      expect { subject }.to change { Article.find(article.id).title }.from(article.title).to (params[:article][:title])
      expect { subject }.not_to change { Article.find(article.id).text }
      expect { subject }.not_to change { Article.find(article.id).created_at}
      expect(response).to have_http_status(200)

    end
  end
end
