class Work < ApplicationRecord
	acts_as_taggable
	attachment :service_image

	validates :service_name, presence: true
	validates :url, presence: true
	validates :service_image, presence: true
	# # 同じurlを登録できないようにする
	validates :url, :uniqueness => {:scope => :user_id}
end
