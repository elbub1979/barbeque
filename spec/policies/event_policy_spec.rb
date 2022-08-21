require 'rails_helper'
require 'pundit/rspec'

RSpec.describe EventPolicy do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  let(:event) { FactoryBot.create(:event, user_id: user2.id) }

  subject { EventPolicy }

  context 'without authorize user' do
    let(:event_context) { EventContext.new(event: event, pincode: nil) }

    permissions :create? do
      it 'should not permit to create event' do
        is_expected.not_to permit(nil, event_context)
      end
    end
  end

  context 'with authorize user' do
    let(:event_context) { EventContext.new(event: event, pincode: nil) }

    permissions :create? do
      it 'should permit to create event' do
        is_expected.to permit(user1, event_context)
      end
    end
  end


  context 'event without pincode' do
    before { event.pincode = nil }
    let(:event_context) { EventContext.new(event: event, pincode: nil) }

    context 'without authorize user' do
      permissions :show? do
        it 'should permit to show event' do
          is_expected.to permit(nil, event_context)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it 'should not permit to edit, update, destroy event' do
          is_expected.not_to permit(nil, event_context)
        end
      end
    end

    context 'with authorize user' do
      context 'user is not owner' do
        permissions :show? do
          it 'should permit to show event' do
            is_expected.to permit(user1, event_context)
          end
        end

        permissions :edit?, :update?, :destroy? do
          it 'should not permit to edit, update, destroy event' do
            is_expected.not_to permit(nil, event_context)
          end
        end

        context 'user is owner' do
          permissions :show? do
            it 'should permit to show event' do
              is_expected.to permit(user2, event_context)
            end
          end

          permissions :edit?, :update?, :destroy? do
            it 'should not permit to edit, update, destroy event' do
              is_expected.not_to permit(nil, event_context)
            end
          end
        end
      end
    end
  end

  context 'event with pincode' do
    before { event.pincode = '123' }

    context 'without authorize user' do

      context 'non authorized user without pincode' do
        let(:event_context) { EventContext.new(event: event, pincode: nil) }

        permissions :show? do
          it 'should not permit to show event' do
            is_expected.not_to permit(nil, event_context)
          end
        end

        permissions :edit?, :update?, :destroy? do
          it 'should not permit to edit, update, destroy event' do
            is_expected.not_to permit(nil, event_context)
          end
        end
      end

      context 'non authorized user with pincode' do
        let(:event_context) { EventContext.new(event: event, pincode: '123') }

        permissions :show? do
          it 'should permit to show event' do
            is_expected.to permit(nil, event_context)
          end
        end

        permissions :edit?, :update?, :destroy? do
          it 'should not permit to edit, update, destroy event' do
            is_expected.not_to permit(nil, event_context)
          end
        end
      end
    end

    context 'with authorize user' do
      context 'user is not owner' do
        context 'without pincode' do
          let(:event_context) { EventContext.new(event: event, pincode: nil) }

          permissions :show? do
            it 'should not permit to show event' do
              is_expected.not_to permit(user1, event_context)
            end
          end

          permissions :edit?, :update?, :destroy? do
            it 'should not permit to edit, update, destroy event' do

              is_expected.not_to permit(user1, event_context)
            end
          end
        end

        context 'with pincode' do
          let(:event_context) { EventContext.new(event: event, pincode: '123') }

          permissions :show? do
            it 'should permit to show event' do
              is_expected.to permit(user1, event_context)
            end
          end

          permissions :edit?, :update?, :destroy? do
            it 'should not permit to edit, update, destroy event' do
              is_expected.not_to permit(user1, event_context)
            end
          end
        end
      end

      context 'user is owner' do
        let(:event_context) { EventContext.new(event: event, pincode: nil) }

        permissions :show? do
          it 'should permit to show event' do
            is_expected.to permit(user2, event_context)
          end
        end

        permissions :edit?, :update?, :destroy? do
          it 'should permit to edit, update, destroy event' do
            is_expected.to permit(user2, event_context)
          end
        end
      end
    end
  end
end
