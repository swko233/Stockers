class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

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

  #twitterログイン
  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first #ユニークキーで検索

    #uidとproviderの組み合わせが見つかった場合
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        twitter_image_url: auth.info.image,
        name: auth.info.name,
        nickname: auth.info.nickname,
      )
    end

    user
  end

  # 通常サインアップ時のuid用、Twitter OAuth認証時のemail用にuuidな文字列を生成
  def self.create_unique_string
    SecureRandom.uuid
  end

  private

  def self.dummy_email(auth)
    #必ず一意なメールアドレスになる
    "#{auth.uid}-#{auth.provider}@example.com"
  end

end
