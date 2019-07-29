require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations', type: :request do
  describe 'POST /api/v1/auth' do
    subject { post(api_v1_user_registration_path, params: params) }

    context '全ての値を入力した時' do
      let(:params) { attributes_for(:user) }
      it 'ユーザー登録できる' do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(200)

        res = JSON.parse(response.body)
        expect(res['status']).to eq 'success'
        expect(res['data']['id']).to eq(User.last.id)
        expect(res['data']['email']).to eq(User.last.email)
        expect(res['data']['provider']).to eq 'email'
      end
    end

    context 'emailが入力されていない時' do
      let(:current_user) { build(:user) }
      let(:params) { { email: nil } }
      it 'エラーになる' do
        subject
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res['errors']['email']).to match_array ["can't be blank"]
        expect(response).to have_http_status(422)
      end
    end
    context 'passwordが入力されていない時' do
      let(:current_user) { attributes_for(:user) }
      let(:params) { { password: nil } }
      it 'エラーになる' do
        subject
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res['errors']['password']).to match_array ["can't be blank"]
        expect(response).to have_http_status(422)
      end
    end

    context 'すでに存在しているemailを登録しようとした時' do
      let!(:current_user) { create(:user, email: "test@email.com") }
      let(:params) { { email: current_user.email } }
      it 'エラーになる' do
        subject
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res['errors']['email']).to match_array ['has already been taken']
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'POST /api/v1/auth/sign_in' do
    subject { post(api_v1_user_session_path, params: params) }
    context 'emailとpassowordが正しく入力された時' do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: current_user.password } }
      it 'ログインに成功する' do
        subject
        expect(response).to have_http_status(200)
        headers = response.headers
        expect(headers['access-token']).to be_present
        expect(headers['token-type']).to be_present
        expect(headers['client']).to be_present
        expect(headers['expiry']).to be_present
        expect(headers['uid']).to be_present
      end
    end

    context 'emailが間違って入力された時' do
      let(:current_user) { create(:user) }
      let(:params) { { email: 'sample@gmail.com', password: current_user.password } }
      it 'ログインに失敗する' do
        subject
        res = JSON.parse(response.body)
        expect(res['success']).to be false
        expect(res['errors']).to include 'Invalid login credentials. Please try again.'
        expect(response).to have_http_status(401)

        headers = response.headers
        expect(headers['access-token']).to be_blank
        expect(headers['token-type']).to be_blank
        expect(headers['client']).to be_blank
        expect(headers['expiry']).to be_blank
        expect(headers['uid']).to be_blank
      end
    end

    context 'passwordが間違って入力された時' do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: 'test-password' } }
      it 'ログインに失敗する' do
        subject
        res = JSON.parse(response.body)
        expect(res['success']).to be false
        expect(res['errors']).to include 'Invalid login credentials. Please try again.'
        expect(response).to have_http_status(401)

        headers = response.headers
        expect(headers['access-token']).to be_blank
        expect(headers['token-type']).to be_blank
        expect(headers['client']).to be_blank
        expect(headers['expiry']).to be_blank
        expect(headers['uid']).to be_blank
      end
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    subject { delete(destroy_api_v1_user_session_path, params: params, headers: headers) }
    context 'ログインしている時' do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: current_user.password }}
      let(:headers) { authentication_headers_for(current_user) }
        it 'サインアウトできる' do
          post(api_v1_user_session_path, params: params)
          delete(destroy_api_v1_user_session_path, { headers: {
            uid: response.headers['uid'],
            client: response.headers['client'],
            "access-token": response.headers['access-token']
          } })

          res = JSON.parse(response.body)
          expect(res['success']).to be true
          expect(response).to have_http_status(200)
        end
    end
  end
end
