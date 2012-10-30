# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  page.body.should =~ regexp
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  rating_array = rating_list.split(', ')
  rating_array.each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then /I should see all of the movies/ do
  
  movies_in_database = Movie.find(:all).length
  rows_of_movies = page.body.scan(/<tr>/).length - 1
  if movies_in_database != rows_of_movies
    
    flunk "Movies do not match number of rows"
  end
  #movies_in_database.should == rows_of_movies
end
