class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  has_many :likeds,
           class_name: 'Like',
           foreign_key: 'liked_post_id',
           dependent: :destroy
  has_many :liked_users, through: :likeds

  private

  # 验证上传的图像大小
  def picture_size
    errors.add(:picture, 'should be less than 5MB') if picture.size > 5.megabytes
  end
end
