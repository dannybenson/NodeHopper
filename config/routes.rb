TeamKen::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'home#index'
  get '/typeahead' => 'home#typeahead'
  get '/search' => 'home#show'
  get '/top' => 'home#top'
  get '/nodes' => "home#nodes"
  post '/d3_3' => 'home#d3_3'

end
