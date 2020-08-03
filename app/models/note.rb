class Note < ActiveRecord::Base
  belongs_to :user

  named_scope :is_public, lambda { { :conditions => 'public  = true' } }

  validates_presence_of :title, :content

  before_save :generate_public_token

  def self.public_notes
    Note.is_public.all :joins => :user,
                       :select => 'title, content, notes.created_at, public_token, user_id,
                                   users.user_name AS user_name, users.avatar AS avatar'
  end

  def self.public_search(conditions)
    Note.is_public.all :joins => :user,
                       :select => 'title, content, notes.created_at, public_token, user_id,
                                   users.user_name AS user_name, users.avatar AS avatar',
                       :conditions => ["content like ?", "%#{conditions}%"] 
  end

  private
    def generate_public_token
      if self.public
        self.public_token = Services::UserServices.generate_token
      end
    end
end
