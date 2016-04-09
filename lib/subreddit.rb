class Subreddit

	attr_accessor :name, :title, :subscribers, :front_page_posts

	def initialize(name, title, subscribers)
		@name = name
		@title = title
		@subscribers = subscribers
		@front_page_posts = []
	end

	def add_posts(array_of_posts)
		array_of_posts.each do |post|
			@front_page_posts << post
		end
	end

end