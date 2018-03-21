class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, :class_name => 'User'

  validates :user_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }

  def short_content
    if content.length >= 20
      content[0, 19] + '...'
    else
      content
    end
  end
end
