require 'rails_helper'

RSpec.describe 'Mypages', type: :request do
  describe 'GET /api/v1/mypages' do
    context 'ログインしたユーザがmypageに遷移した時' do
      subject { get(api_v1_mypage_path, headers: headers) }
      let(:current_user) { create(:user) }
      let(:headers) { authentication_headers_for(current_user) }

      let!(:article1) { create(:article, user: current_user, created_at: 1.days.ago) }
      let!(:article2) { create(:article, user: current_user, created_at: 2.days.ago) }
      let!(:article3) { create(:article, user: current_user) }

      it '記事の一覧が表示される（投稿順）' do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "title", "text", "created_at", "user"]
        expect(res[0]['id']).to match(article3.id)
        expect(res[1]['id']).to match(article1.id)
        expect(res[2]['id']).to match(article2.id)
        expect(response).to have_http_status(200)
        expect { res.map { |s| s['status'] }. to eq 'published' }
      end
    end
  end
end
