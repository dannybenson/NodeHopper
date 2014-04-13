# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'JSON'

json = JSON.parse(File.read('db/cj.json'))
json.merge(JSON.parse(File.read('db/kl.json')))
json.merge(JSON.parse(File.read('db/ka.json')))
json.merge(JSON.parse(File.read('db/gs.json')))
json.merge(JSON.parse(File.read('db/ss.json')))

friends = json['friends']['data']
user_movies = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Movie'} != []
    user_movies[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Movie'}
  end
end

user_music = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Musician/band'} != []
    user_music[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Musician/band'}
  end
end

user_tv = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Tv show'} != []
    user_tv[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Tv show'}
  end
end

user_book = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Book'} != []
    user_book[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Book'}
  end
end

user_author = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Author'} != []
    user_author[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Author'}
  end
end

user_np = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'} != []
    user_np[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'}
  end
end

user_np = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'} != []
    user_np[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'}
  end
end

user_videogame = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Video game'} != []
    user_videogame[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Video game'}
  end
end


user_game = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Games/toys'} != []
    user_game[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Games/toys'}
  end
end
# user_movies.each do |k,v|
#   if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "user")
#   end
#   v.each do |movie|
#     if m = @neo.find_nodes_labeled('movie', {:name => movie["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => movie['name'])
#       @neo.add_label(m, ["movie", "interest"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_music.each do |k,v|
#   if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "user")
#   end
#   v.each do |music|
#     if m = @neo.find_nodes_labeled('music', {:name => music["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => music['name'])
#       @neo.add_label(m, ["music", "interest"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end


# user_tv.each do |k,v|
#   if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "user")
#   end
#   v.each do |tv|
#     if m = @neo.find_nodes_labeled('tv', {:name => tv["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => tv['name'])
#       @neo.add_label(m, ["tv", "interest"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end

user_book.each do |k,v|
  if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "user")
  end
  v.each do |book|
    if m = @neo.find_nodes_labeled('book', {:name => book["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => book['name'])
      @neo.add_label(m, ["book", "interest"])
    end
      @neo.create_relationship("like", user, m)
  end
end

user_author.each do |k,v|
  if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "user")
  end
  v.each do |author|
    if m = @neo.find_nodes_labeled('author', {:name => author["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => author['name'])
      @neo.add_label(m, ["author", "interest"])
    end
      @neo.create_relationship("like", user, m)
  end
end

user_np.each do |k,v|
  if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "user")
  end
  v.each do |np|
    if m = @neo.find_nodes_labeled('non-profit', {:name => np["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => np['name'])
      @neo.add_label(m, ["non-profit", "interest"])
    end
      @neo.create_relationship("like", user, m)
  end
end

user_videogame.each do |k,v|
  if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "user")
  end
  v.each do |videogame|
    if m = @neo.find_nodes_labeled('videogame', {:name => videogame["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => videogame['name'])
      @neo.add_label(m, ["videogame", "interest"])
    end
      @neo.create_relationship("like", user, m)
  end
end

user_game.each do |k,v|
  if user = @neo.find_nodes_labeled('user', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "user")
  end
  v.each do |game|
    if m = @neo.find_nodes_labeled('game', {:name => game["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => game['name'])
      @neo.add_label(m, ["game", "interest"])
    end
      @neo.create_relationship("like", user, m)
  end
end

# @neo.create_schema_index("interest", ["name"])
# @neo.create_schema_index("movie", ["name"])
# @neo.create_schema_index("music", ["name"])
# @neo.create_schema_index("tv", ["name"])
@neo.create_schema_index("book", ["name"])
@neo.create_schema_index("author", ["name"])
@neo.create_schema_index("non-profit", ["name"])
@neo.create_schema_index("videogame", ["name"])
@neo.create_schema_index("game", ["name"])


