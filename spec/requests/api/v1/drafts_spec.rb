# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Drafts', type: :request do
  describe 'GET /drafts' do
    subject { get(api_v1_drafts_path, headers: headers) }
    context 'ユーザがログインしている時' do
      let(:current_user) { create(:user) }
      let(:headers) { authentication_headers_for(current_user) }

      let!(:article1) { create(:article, :draft, user: current_user) }
      let!(:article2) { create(:article, :draft, user: current_user) }
      let!(:article3) { create(:article, :draft, user: current_user) }

      it 'ログインしているユーザのの下書き一覧が表示される' do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq %w[id title updated_at user]
        expect(res[0]['user'].keys).to eq %w[id name email]
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /drafts/:id' do
    subject { get(api_v1_draft_path(article.id), headers: headers) }
    context 'ユーザがログイン中かつ' do
      let(:current_user) { create(:user) }
      let(:headers) { authentication_headers_for(current_user) }

      context '指定したidのarticleのstatusがdraftの時' do
        let(:article) { create(:article, :draft, user: current_user) }

        it 'articleの値が取得できる' do
          subject
          res = JSON.parse(response.body)
          expect(res['id']).to eq article.id
          expect(res['title']).to eq article.title
          expect(res['text']).to eq article.text
          expect(res['updated_at']).to be_present
          expect(res['user']['id']).to eq article.user.id
          expect(res['user'].keys).to eq %w[id name email]
          expect(response).to have_http_status(200)
        end
      end

      context '指定したidのarticleのstatusがpublishedの時' do
        let(:article) { create(:article, :published, user: current_user) }
        it 'articleの値が取れない' do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context '異なるuserのstatusがdraftである記事を取得しようとした時' do
        let(:current_user) { create(:user, id: 1) }
        let(:headers) { authentication_headers_for(current_user) }
        let(:article) { create(:article, :draft) }

        it 'articleの値が取れない' do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
