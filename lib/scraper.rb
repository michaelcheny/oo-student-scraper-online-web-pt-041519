require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    # binding.pry
    doc.css("div.student-card a").each do |student|
      name = student.css("h4").text
      location = student.css("p").text
      profile_url = student.attr("href")
      students << {name: name, location: location, profile_url: profile_url}
    end
      students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student_profile = {}
    # binding.pry
    doc.css("div.social-icon-container a").each do |link|
      # binding.pry
      website = link.attr("href")
      if website.include?("twitter")
        student_profile[:twitter] = website
      elsif website.include?("github")
        student_profile[:github] = website
      elsif website.include?("linkedin")
        student_profile[:linkedin] = website
      else
        student_profile[:blog] = website
      end
    end
    # binding.pry
    student_profile[:profile_quote] = doc.css("div.profile-quote").text
    student_profile[:bio] = doc.css("div.description-holder p").text
    student_profile
  end

end

