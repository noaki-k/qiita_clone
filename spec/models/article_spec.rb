require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'titleとtextが入力されている時' do
    it 'articleが作られる' do
      user = FactoryBot.create(:user)
      article = FactoryBot.create(:article, user: user)
      expect(article).to be_valid
    end
  end

  context 'titleが入力されていない時' do
    it 'エラーする' do
      user = FactoryBot.create(:user)
      article = FactoryBot.build(:article, title: nil, user: user)
      article.valid?

      expect(article.errors.messages[:title]).to include "can't be blank"
    end
  end

  context 'textが入力されていない時' do
    it 'エラーする' do
      user = FactoryBot.create(:user)
      article = FactoryBot.build(:article, text: nil, user: user)
      article.valid?

      expect(article.errors.messages[:text]).to include "can't be blank"
    end
  end
end
