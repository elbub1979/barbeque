class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: URI::MailTo::EMAIL_REGEXP, unless: -> { user.present? }

  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }
  validate :event_creator

  # validate :email_is_use?

  # before_validation :user_email_downcase

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
    if event.user == user
      errors.add(:event_creator, "activerecord.validates.errors.subscription.event_creator")
    end
  end

  # def user_email_downcase
  #  user_email.downcase!
  # end

  # def email_is_use?
  # if User.where('email = ?', user_email.downcase).first
  #   errors.add(:user_email, 'activerecord.validates.errors.subscription.user_email')
  #  end
  # end
end
