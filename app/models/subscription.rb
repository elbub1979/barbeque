class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validate :event_author_presence

  with_options if: :user_present? do
    validates :user, uniqueness: { scope: :event_id, message: I18n.t('already_subscribed') }
  end

  with_options unless: :user_present? do
    validates :user_name, presence: true
    validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: :wrong_email },
                           uniqueness: { message: :subscribe_user_email }
    validate :user_presence
  end

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

  def user_email_downcase
    user_email.downcase! if user_email.present?
  end

  def event_author_presence
    errors.add(:user_email, :event_creator) if event.user.email == user_email
  end

  def user_presence
    errors.add(:user_email, :user_presence) if User.excluding(event.user).exists?(email: user_email)
  end

  def user_present?
    user.present?
  end
end
