class Work < ApplicationRecord
	acts_as_taggable
	attachment :service_image

	belongs_to :user
	has_many :comments
	has_many :favorites

	validates :service_name, presence: true
	validates :url, presence: true
	validates :service_image, presence: true
	# # 同じurlを登録できないようにする
	validates :url, :uniqueness => {:scope => :user_id}

	#いいね!ボタンの色分けに使用
	def favorite_by?(user)
		favorites.where(user_id: user.id).exists?
	end

end
