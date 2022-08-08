require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  context '1' do
    it 'name' do
      expect(user.name).to eq('someguy_1')
    end
  end
end
