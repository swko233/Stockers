class Bookmark < ApplicationRecord
	acts_as_taggable
	attachment :service_image

	belongs_to :user
end
