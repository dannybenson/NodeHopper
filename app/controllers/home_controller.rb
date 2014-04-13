class HomeController < ApplicationController
  def index
  end

  def template
  end

  def typeahead
    render json: Interest.get_interest_names
  end
 
 	def show
 		render json: {
		  title: "params",
		  children: [
		  {
		    title: "Movies",
		    children:[
		    {title: "Departed",
		      data: 30},
		    {title: "The Shining",
		      data: 70},
		    {title:"The Help",
		      data: 90},
		    {title:"Tomoe",
		      data: 50}
		    ]
		  },
		  {
		    title: "Books",
		    children:[
		    {title:"1984",
		      data: 30},
		    {title:"Mockingjay",
		      data: 69},
		    {title:"Brave New World",
		      data: 23}
		    ]
		  },
		  {
		    title: "TV shows",
		    children:[
		    {title:"OOT",
		      data: 78},
		    {title:"Something Good",
		      data: 20},
		    {title:"Cosmos",
		      data: 92}
		    ]
		  }
		  ]
		}

 	end

end
