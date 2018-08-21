class Bookmark < ApplicationRecord
	acts_as_taggable
	attachment :service_image

	belongs_to :user

	validates :service_name, presence: true
	validates :url, presence: true
	# # 同じurlを登録できないようにする
	validates :url, :uniqueness => {:scope => :user_id}

	def self.search_bookmark(search)
	    if search
	      Bookmark.where(['(service_name LIKE ?)',"%#{search}%"])
	    else
	      Bookmark.all
	    end
	 end

end
