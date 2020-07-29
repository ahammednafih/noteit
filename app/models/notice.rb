class Notice < ActiveRecord::Base
  before_save :generate_public_token

  belongs_to :user

  validates_presence_of :title, :content

  def self.public_notes
    Notice.find_by_sql(
                        "SELECT notices.title, notices.content, notices.created_at, 
                        notices.public_token, users.id AS user_id, users.user_name AS user_name, 
                        users.avatar AS avatar from notices 
                        INNER JOIN users ON notices.user_id = users.id 
                        where notices.public = true"
                      )
  end

  def self.public_search(conditions)
    # Notice.all(:conditions => ["content like ? and public like ?", "%#{conditions}%", 1])
    Notice.find_by_sql(
      "SELECT notices.title, notices.content, notices.created_at, 
      notices.public_token, users.id AS user_id, users.user_name AS user_name, 
      users.avatar AS avatar from notices 
      INNER JOIN users ON notices.user_id = users.id 
      where notices.content LIKE '%#{conditions}%' AND notices.public = true"
    )
  end

  private
    def generate_public_token
      if self.public
        self.public_token = SecureRandom.base64.gsub('/"', '_').to_s
      end
    end
end
