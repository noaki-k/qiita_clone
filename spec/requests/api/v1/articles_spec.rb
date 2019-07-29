require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  # index method
  describe 'GET /articles' do
    subject { get(api_v1_articles_path) }

    before { create_list(:article, 3) }

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
    subject { get(api_v1_article_path(article_id)) }

    context '指定した id のarticleが存在する場合' do
      #PR#38FactoryBotの修正により記述を簡潔に
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it 'articleの値が取得できる' do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res['id']).to eq article.id
        expect(res['title']).to eq article.title
        expect(res['text']).to eq article.text
        expect(res['user']['id']).to eq article.user.id
        expect(res['user'].keys).to eq ['id', 'name', 'email']
      end
    end

    context '指定した id のarticleが存在しない場合' do
      # PR#38：article_idを必ず存在しない番号にするために
      # 本来は9999をArticle.last.id + 1と書いた方がベター
      let(:article_id) { 9999 }
      it 'articleが見つからない' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  #update method
  describe 'PATCH /articles/:id' do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }
    let(:current_user) { create(:user) }

    let(:params) { { article: attributes_for(:article) } }
    let(:headers) { authentication_headers_for(current_user) }

    context "自分が所持している記事のタイトルを更新しようとするとき" do
      let(:article) { create(:article, user: current_user) }
      it '指定したarticleのレコードが更新される' do
        # PR#40
        expect { subject }.to change{ Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
        change{ Article.find(article.id).text } &
        not_change { Article.find(article.id).created_at }
        expect(response).to have_http_status(200)
      end
    end
  end

  #destroy method
  describe 'DELETE /articles/:id' do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let!(:article) { create(:article) }
    let(:current_user) { create(:user) }
    let(:headers) { authentication_headers_for(current_user) }

    it '指定したarticleのレコードが削除される' do
      expect { subject }.to change { Article.count }.by(-1)
      expect(response).to have_http_status(204)
    end
  end

  #create method
  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:params) { { article: attributes_for(:article) } }
    let(:headers) { authentication_headers_for(current_user) }

    it "articleのレコードが作成される" do
      expect { subject }.to change { Article.count }.by(1)
      expect(response).to have_http_status(200)
    end
  end
end
