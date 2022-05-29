class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :events, dependent: :delete_all
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :delete_all

  # validates :name, presence: true, length: { maximum: 35 }

  # before_validation :set_name, on: :create

  private

  def set_name
    self.name = "Товарисч №#{rand(777)}" if name.blank?
  end
end
