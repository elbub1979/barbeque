class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google]

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :photos, dependent: :destroy

  has_one_attached :avatar, dependent: :destroy do |attachable|
    attachable.variant :thumb, resize_to_fill: [25, 25]
    attachable.variant :avatar, resize_to_fill: [350, 350]
  end

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 35 }

  after_commit :link_subscriptions, on: :create

  def author?(event)
    event.user == self
  end

  def self.find_for_github_oauth(access_token)
    byebug
  end

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: email).update_all(user_id: id)
  end

  def downcase_email
    email.downcase! if email.present?
  end
end
