require 'rails_helper'

RSpec.describe 'Mypages', type: :request do
  describe 'GET /api/v1/mypages' do
    subject { get (authenticate_api_v1_user!) }
    context 'userが持つ記事の数だけ表示される'
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }
    it 'works! (now write some real specs)' do
      subject
      expect(response).to have_http_status(200)
    end
  end
end
