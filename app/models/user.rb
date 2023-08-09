class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google_oauth2]

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

  def self.github_from_omniauth(access_token)
    # Достаём email из токена
    email = access_token.info.email
    name = access_token.info.name
    user = where(email: email).first

    # Возвращаем, если нашёлся
    return user if user.present?

    # Если не нашёлся, достаём провайдера, айдишник и урл
    provider = access_token.provider
    url = "https://github.com/#{name}"

    # Теперь ищем в базе запись по провайдеру и урлу
    # Если есть, то вернётся, если нет, то будет создана новая
    where(url: url, provider: provider).first_or_create! do |user|
      # Если создаём новую запись, прописываем email и пароль
      user.name = name
      user.email = email
      user.password = Devise.friendly_token.first(16)
    end
  end

  def self.google_from_omniauth(access_token)
    email = access_token.info.email
    name = access_token.info.name
    user = where(email: email).first

    return user if user.present?

    provider = access_token.provider
    url = "https://plus.google.com/+#{name.gsub(/\s+/, '')}" # не смог найти возможность получения корректной ссылк на профиль

    where(url: url, provider: provider).first_or_create! do |user|
      user.name = name
      user.email = email
      user.password = Devise.friendly_token.first(16)
    end
  end

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: email).update_all(user_id: id)
  end

  def downcase_email
    email.downcase! if email.present?
  end
end
