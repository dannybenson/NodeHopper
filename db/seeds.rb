#needs unique node implementation for all nodes
require 'JSON'
require 'byebug'
json = JSON.parse(File.read('db/kl.json'))
json = json | JSON.parse(File.read('db/cj.json'))
json = json | JSON.parse(File.read('db/gs.json'))
json = json | JSON.parse(File.read('db/ka.json'))
json = json | JSON.parse(File.read('db/ss.json'))


p json.count


categories = ["Movie", "Musician/band", "Tv show", "Book", "Non-profit organization", "Author", "Video game", "Games/toys" ]

json = json.reject{ |obj| obj["likes"].nil? }
p json.count
@neo = Neography::Rest.new

def find_or_create_by(label, name, neo)
  if neo.find_nodes_labeled(label, {"name" => name}).empty?
    node = @neo.create_node("name" => name)
    neo.add_label(node, ["Interest", label])
    node
  else
    neo.find_nodes_labeled(label, {"name" => name}).first
  end
end

json.each do |obj|
  person = @neo.create_node("user_id_hash" => obj["id"].hash)
  @neo.add_label(person, "Person")
  categories.each do |category|
    # byebug
    filter_likes = obj["likes"]["data"].select {|like| like["category"] == category }
    filter_likes.each do |like|
      # p category
      interest = find_or_create_by(category, like["name"], @neo)
      @neo.create_relationship("like", person, interest)
    end
  end
end




# friends = json['friends']['data']
# user_movies = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Movie'} != []
#     user_movies[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Movie'}

# end
# user_music = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Musician/band'} != []
#     user_music[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Musician/band'}
#   end
# end
# user_tv = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Tv show'} != []
#     user_tv[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Tv show'}
#   end
# end
# user_book = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Book'} != []
#     user_book[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Book'}
#   end
# end
# user_nonprofit = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'} != []
#     user_nonprofit[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'}
#   end
# end
# user_author = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Author'} != []
#     user_author[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Author'}
#   end
# end
# user_videogame = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Video game'} != []
#     user_videogame[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Video game'}
#   end
# end

# user_game = {}
# friends.each do |friend|
#   if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Games/toys'} != []
#     user_game[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Games/toys'}
#   end
# end

# user_movies.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |movie|
#     if m = @neo.find_nodes_labeled('movie', {:name => movie["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => movie['name'])
#       @neo.set_label(m, ["Interest", "Movie"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_music.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |music|
#     if m = @neo.find_nodes_labeled('music', {:name => music["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => music['name'])
#       @neo.set_label(m, ["Interest", "Music"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_tv.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |tv|
#     if m = @neo.find_nodes_labeled('tv', {:name => tv["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => tv['name'])
#       @neo.set_label(m, ["Interest", "Tv"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_book.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |book|
#     if m = @neo.find_nodes_labeled('Book', {:name => book["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => book['name'])
#       @neo.set_label(m, ["Interest", "Book"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_nonprofit.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |np|
#     if m = @neo.find_nodes_labeled('Non-profit', {:name => np["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => np['name'])
#       @neo.set_label(m, ["Interest", "Non-profit"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_author.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |a|
#     if m = @neo.find_nodes_labeled('Author', {:name => a["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => a['name'])
#       @neo.set_label(m, ["Interest", "Author"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end
# user_videogame.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |a|
#     if m = @neo.find_nodes_labeled('Videogame', {:name => a["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => a['name'])
#       @neo.set_label(m, ["Interest", "Videogame"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end

# user_game.each do |k,v|
#   if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
#     "whatever"
#   else
#     user = @neo.create_node("user_id" => k)
#     @neo.add_label(user, "Person")
#   end
#   v.each do |a|
#     if m = @neo.find_nodes_labeled('Game', {:name => a["name"]}).first
#       "whatever"
#     else
#       m = @neo.create_node('name' => a['name'])
#       @neo.set_label(m, ["Interest", "Game"])
#     end
#       @neo.create_relationship("like", user, m)
#   end
# end

# @neo.create_schema_index("Interest", ['name'])
# @neo.create_schema_index("Movie", ['name'])
# @neo.create_schema_index("Music", ['name'])
# @neo.create_schema_index("Tv", ['name'])
# @neo.create_schema_index("Book", ['name'])
# @neo.create_schema_index("Non-profit", ['name'])
# @neo.create_schema_index("Author", ['name'])
# @neo.create_schema_index("Videogame", ['name'])
# @neo.create_schema_index("Game", ['name'])

