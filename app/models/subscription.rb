class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true


  with_options if: :user_present? do
    validates :user, uniqueness: { scope: :event_id }
  end

  with_options unless: :user_present? do
    validates :user_name, presence: true
    validates :user_email, presence: true, format: URI::MailTo::EMAIL_REGEXP
    validate :event_subscription
    validate :event_author
    validate :registered_user
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

  def event_author
    errors.add(:user_email, :event_creator) if event.user.email == user_email
  end

  def event_subscription
    errors.add(:user_email, :subscribe_user_email) if event.subscriptions.exists?(user: User.where(email: user_email))
  end

  def registered_user
    errors.add(:user_email, :present_user) if User.exists?(email: user_email)
  end

  def user_present?
    user.present?
  end
end
