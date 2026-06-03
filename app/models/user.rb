class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :notes, dependent: :destroy
  has_one_attached :avatar

  validates :user_name, presence: true, uniqueness: { case_sensitive: false }
  validates :user_name, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }
  validates :first_name, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }, allow_blank: true
  validates :last_name, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ }, allow_blank: true

  before_save :set_full_name

  def set_full_name
    self.full_name = "#{first_name} #{last_name}".strip
  end
end
