class Post

	attr_accessor :title, :points, :author, :comment_count

	def initialize(title, points, author, comment_count)
		@title = title
		@points = points
		@author = author
		@comment_count = comment_count
	end

end