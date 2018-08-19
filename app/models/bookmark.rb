class Bookmark < ApplicationRecord
	acts_as_taggable
	attachment :service_image

	belongs_to :user

	def self.search_bookmark(search)
	    if search
	      Bookmark.where(['(service_name LIKE ?)',"%#{search}%"])
	    else
	      Bookmark.all
	    end
	 end

end
