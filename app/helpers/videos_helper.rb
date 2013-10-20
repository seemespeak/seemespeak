module VideosHelper
	def length_collection
		[3, 5, 10].map do |length|
			["#{length} #{t :seconds}", length]
		end
	end
end
