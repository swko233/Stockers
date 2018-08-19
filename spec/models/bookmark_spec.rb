require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# ユーザーデータがないとアソシエーションの関係でtranslation missingエラーになるため、データを用意するか一旦アソシエーションを解除して実行する。
RSpec.describe Bookmark, type: :model do
	context 'should be invalid' do
		before do
	        @bookmark = Bookmark.new()
	   	end
	    it 'without a service_name' do
	    	@bookmark.url = "x"
	    	expect(@bookmark).to be_invalid
	    end
	    it 'without a url' do
	    	@bookmark.service_name = "x"
	    	expect(@bookmark).to be_invalid
	    end
	end
	context 'should be valid' do
		before do
			@bookmark = Bookmark.new(
						url: "x",
						service_name: "x")
			@bookmark.save
		end
		it 'with service_name and url' do
			expect(@bookmark).to be_valid
		end
	end
end