require 'rails_helper'
require 'pundit/rspec'

RSpec.describe EventPolicy do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  let(:event) { FactoryBot.create(:event, user_id: user2.id) }

  subject { EventPolicy }

  context 'user is not owner' do
    permissions :show? do
      it 'should permit to show event' do
        is_expected.to permit(user1, event)
      end
    end

    permissions :edit?, :update?, :destroy? do
      it 'should not permit to edit, update, destroy event' do
        is_expected.not_to permit(user1, event)
      end
    end
  end

  context 'user is owner' do
    permissions :show? do
      it 'should permit to show event' do
        is_expected.to permit(user2, event)
      end
    end

    permissions :edit?, :update?, :destroy? do
      it 'should not permit to edit, update, destroy event' do
        is_expected.to permit(user2, event)
      end
    end
  end
end
