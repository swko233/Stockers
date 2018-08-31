class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :following, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  has_many :bookmarks, dependent: :destroy
  has_many :works
  has_many :comments
  has_many :favorites

  attachment :image
  #developアカウントの許可がおりないため、ツイッターログインは一旦無視
  validates :email, presence: true
  validates :name, presence: true
  validates :nickname, presence: true

  def following?(other_user)
  	following_relationships.find_by(following_id: other_user.id)
  end

  def follow(other_user)
  	following_relationships.create!(following_id: other_user.id)
  end

  def unfollow(other_user)
  	following_relationships.find_by(following_id: other_user.id).destroy
  end

  # 論理削除
  def soft_delete
    update(deleted_at: Time.now)
  end

  # 退会していないという条件を追加
  def active_for_authentication?
    !deleted_at
  end

end
