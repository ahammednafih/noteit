class Note < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include PgSearch::Model
  pg_search_scope :search_by_title_and_content,
                  against: [:title, :content],
                  using: {
                    tsearch: { prefix: true }
                  }

  belongs_to :user

  validates :title, :content, presence: true

  scope :is_public, -> { where(public: true) }

  before_save :generate_public_token

  def self.public_notes
    is_public.joins(:user).select(
      'notes.*, users.user_name AS user_name'
    ).order(created_at: :desc)
  end

  def self.public_search(query)
    public_notes.search_by_title_and_content(query)
  end

  def self.autocomplete_search(query, user = nil)
    wildcard = "%#{query}%"
    scope = if user
      joins(:user)
        .select('notes.*, users.user_name AS user_name')
        .where("notes.public = ? OR notes.user_id = ?", true, user.id)
    else
      public_notes
    end
    scope.where("notes.title ILIKE ? OR notes.content ILIKE ?", wildcard, wildcard)
  end

  private

  def generate_public_token
    if public && public_token.blank?
      self.public_token = SecureRandom.hex(16)
    end
  end
end
