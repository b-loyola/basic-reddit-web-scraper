require 'open-uri'
require 'nokogiri'
require_relative './lib/scraper'
require_relative './lib/subreddit'
require_relative './lib/post'

# Colours
RED = "\e[31m"
GREEN = "\e[32m"
BROWN = "\e[33m"
MAGENTA = "\e[35m"
WHITE = "\e[7m"
RESET_COLOUR = "\e[0m"

if Scraper.wrong_number_args?(ARGV)
	puts "wrong number of arguments"
	puts "correct usage: ruby reddit_scraper.rb https://www.reddit.com/r/example/"
else
	begin
		scraper = Scraper.new(ARGV[0])
		subreddit = scraper.scrape
		puts "#{BROWN}Subreddit name#{RESET_COLOUR}: #{subreddit.name}"
		puts "#{BROWN}Subreddit title#{RESET_COLOUR}: #{subreddit.title}"
		puts "#{MAGENTA}Subreddit subscribers#{RESET_COLOUR}: #{subreddit.subscribers}"
		puts "#{MAGENTA}Number of front page posts#{RESET_COLOUR}: #{subreddit.front_page_posts.size}"
		puts "#{RED}** Front Page Posts **#{RESET_COLOUR}"
		subreddit.front_page_posts.each do |post|
			puts "#{WHITE}Title#{RESET_COLOUR}: #{post.title}"
			puts "#{GREEN}Net upvotes#{RESET_COLOUR}: #{post.points}"
			puts "#{BROWN}Author#{RESET_COLOUR}: #{post.author}"
			puts "#{BROWN}Comment count#{RESET_COLOUR}: #{post.comment_count}"
		end
	rescue Scraper::InvalidURL => e
		puts e.message
	end
end