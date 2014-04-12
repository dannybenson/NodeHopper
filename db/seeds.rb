#needs unique node implementation for all nodes
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

user_nonprofit = {}
friends.each do |friend|
  if friend['likes'] && friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'} != []
    user_nonprofit[friend['id']] = friend['likes']['data'].select { |interest| interest['category'] == 'Non-profit organization'}
  end
end

user_movies.each do |k,v|
  if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "Person")
  end
  v.each do |movie|
    if m = @neo.find_nodes_labeled('movie', {:name => movie["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => movie['name'])
      @neo.set_label(m, ["Interest", "Movie"])
    end
      @neo.create_relationship("like", user, m)
  end
end
user_music.each do |k,v|
  if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "Person")
  end
  v.each do |music|
    if m = @neo.find_nodes_labeled('music', {:name => music["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => music['name'])
      @neo.set_label(m, ["Interest", "Music"])
    end
      @neo.create_relationship("like", user, m)
  end
end
user_tv.each do |k,v|
  if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "Person")
  end
  v.each do |tv|
    if m = @neo.find_nodes_labeled('tv', {:name => tv["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => tv['name'])
      @neo.set_label(m, ["Interest", "Tv"])
    end
      @neo.create_relationship("like", user, m)
  end
end
user_book.each do |k,v|
  if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "Person")
  end
  v.each do |book|
    if m = @neo.find_nodes_labeled('Book', {:name => book["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => book['name'])
      @neo.set_label(m, ["Interest", "Book"])
    end
      @neo.create_relationship("like", user, m)
  end
end
user_nonprofit.each do |k,v|
  if user = @neo.find_nodes_labeled('Person', {:user_id => k}).first
    "whatever"
  else
    user = @neo.create_node("user_id" => k)
    @neo.add_label(user, "Person")
  end
  v.each do |np|
    if m = @neo.find_nodes_labeled('Non-profit', {:name => np["name"]}).first
      "whatever"
    else
      m = @neo.create_node('name' => np['name'])
      @neo.set_label(m, ["Interest", "Non-profit"])
    end
      @neo.create_relationship("like", user, m)
  end
end

@neo.create_schema_index("Interest", ['name'])
@neo.create_schema_index("Movie", ['name'])
@neo.create_schema_index("Music", ['name'])
@neo.create_schema_index("Tv", ['name'])
@neo.create_schema_index("Book", ['name'])
@neo.create_schema_index("Non-profit", ['name'])
