class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  before_save :downcase_email

  # validates :name, presence: true, length: { maximum: 35 }

  # before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  private

  def set_name
    self.name = "Товарисч №#{rand(777)}" if name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: email).update_all(user_id: id)
  end

  def downcase_email
    email.downcase!
  end
end
