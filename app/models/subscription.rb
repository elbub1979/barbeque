class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  with_options if: :user_present? do
    validates :user, uniqueness: { scope: :event_id }
  end

  with_options unless: :user_present? do
    validates :user_name, presence: true
    validates :user_email, presence: true, format: URI::MailTo::EMAIL_REGEXP
    validates :user_email, uniqueness: { scope: :event_id }
    validate :unregistered_subscriber_email
  end

  validate :event_creator

  before_validation :user_email_downcase

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def event_creator
    errors.add(:event_creator, 'activerecord.validates.errors.subscription.event_creator') if event.user == user
  end

  def user_email_downcase
    user_email.downcase! if user_email.present?
  end

  def unregistered_subscriber_email
    errors.add(:user_email, :subscribe_user_email) if User.find_by('email = ?', user_email)
  end

  def user_present?
    user.present?
  end
end
