class Note < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  validates :title, :content, presence: true

  scope :is_public, -> { where(public: true) }

  before_create :generate_uuid_v7
  before_save :generate_public_token

  def self.public_notes
    is_public.joins(:user).select(
      'notes.*, users.user_name AS user_name'
    ).order(created_at: :desc)
  end

  def self.public_search(query)
    public_notes.where('content ILIKE ?', "%#{query}%")
  end

  private

  def generate_uuid_v7
    self.id ||= SecureRandom.respond_to?(:uuid_v7) ? SecureRandom.uuid_v7 : SecureRandom.uuid
  end

  def generate_public_token
    if public && public_token.blank?
      self.public_token = SecureRandom.hex(16)
    end
  end
end
