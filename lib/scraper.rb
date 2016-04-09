class Scraper

	attr_reader :source_url, :html_page

	class InvalidURL < StandardError; end

	def self.wrong_number_args?(args_array)
		args_array.size != 1
	end

	def initialize(source_url)
		@source_url = source_url
		@html_page = nil
	end

	def update_html(html_page)
		@html_page = html_page
	end

	def valid_url?(url)
		url =~ /^https\:\/\/www\.reddit\.com\/r\/\w+/
	end

	def extract_name
		html_page.css('h1.hover.redditname a').text
	end

	def extract_title
		html_page.css('title').text
	end

	def extract_subscribers
		html_page.css('span.subscribers span.number').text
	end

	def extract_posts
		titles = html_page.css('div.thing div.entry p.title a.title').map {|element| element.text }
		upvotes = html_page.css('div.thing div.midcol div.score.likes').map {|element| element.text }
		authors = html_page.css('div.thing div.entry p.tagline a.author').map {|element| element.text }
		comment_counts = html_page.css('div.thing div.entry ul li.first a[data-event-action=\'comments\']').map do |element| 
			element.text[/\d+/] ? element.text[/\d+/] : "0"
		end
		titles.map.with_index do |title, i|
			Post.new(title, upvotes[i], authors[i], comment_counts[i])
		end
	end

	def scrape
		raise InvalidURL, "url must be a subreddit address" unless valid_url?(@source_url)
		self.update_html(Nokogiri::HTML(open(@source_url)))
		subreddit_name = extract_name
		title = extract_title
		subscribers = extract_subscribers
		subreddit = Subreddit.new(subreddit_name, title, subscribers)
		subreddit.add_posts(extract_posts)
		subreddit
	end

end