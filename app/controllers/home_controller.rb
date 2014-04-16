require 'json'

class HomeController < ApplicationController

  def index
  end

  def template
  	render 'show'
  end

  def typeahead
    render json: Interest.get_interest_names
  end

  def show
    # {"interests" : ["sfwef", "lsdf"]}
    # ["Batman Begins", "The Notebook"] => make into interest objects
    # interests = params[:interests].map{|thing| Interest.find(thing)}
    # render json: {some: "stuff"}
    # render json: Interest.combined_donut(interests)
    # binding.pry
 		render json: Interest.donut(Interest.find("Batman Begins"),20)
 	end

  def d3_2
    render json: Interest.node_matrix(params["search"])
  end

  def children
    render json: Interest.node_matrix(params[:name])
  end

  def data
    # {"name"=>"rudpwxuk","children"=>[{"name"=>"efbnaxae","children"=>[{"name"=>"bnjzysqc","children"=>[{"name"=>"hdbhpfjm","size"=>10},{"name"=>"uubcyqcc","size"=>4},{"name"=>"xbbqhzhz","size"=>10},{"name"=>"xpzybmgz","size"=>5}]},{"name":"cucdxuzs","children":[{"name":"akkwgpau","size":2},{"name":"djyrvrkc","size":10},{"name":"ffmamnar","size":1},{"name":"hyardjpz","size":10},{"name":"mpsrzfbz","size":3},{"name":"tyrkabaj","size":8},{"name":"uvartvvf","size":7}]},{"name":"hvzhargk","children":[{"name":"axvbqkby","size":8},{"name":"hkafxkcd","size":2},{"name":"kyrvvawx","size":7},{"name":"uapkvyvz","size":7}]},{"name":"trkxvzja","children":[{"name":"hqnjfpmh","size":7},{"name":"hsnvrsjz","size":1},{"name":"nnumuwjz","size":6},{"name":"sdkgzrqp","size":4},{"name":"tnewdprg","size":2},{"name":"vehzmqse","size":5},{"name":"xbbqhzhz","size":10}]},{"name":"tsvugjsp","children":[{"name":"kkvmdrjs","size":8},{"name":"mcmwdpfa","size":10},{"name":"mkjdvqqp","size":10},{"name":"yvbwkeyz","size":4},{"name":"yzgtakeq","size":9}]},{"name":"vmjxszcp","children":[{"name":"dnsfgbqb","size":7},{"name":"gadrappa","size":5},{"name":"keydbvcv","size":4},{"name":"qrfertxf","size":1},{"name":"ynqrdgtr","size":2},{"name":"zfrwkxyq","size":8},{"name":"zkqawbfn","size":3}]},{"name":"wcezzwsg","children":[{"name":"djyrvrkc","size":10},{"name":"hvntkmhs","size":6},{"name":"qrfertxf","size":1},{"name":"rgphfyfe","size":3},{"name":"sdkgzrqp","size":4},{"name":"zqgphzar","size":8}]},{"name":"xtdrxckx","children":[{"name":"mgjbqfev","size":4},{"name":"pnuhujqs","size":8},{"name":"ppkevygc","size":9},{"name":"qrfertxf","size":1},{"name":"vvtjvdxw","size":9}]}]},{"name":"nubsyyrg","children":[{"name":"faapdvdg","children":[{"name":"jkxjzjxb","size":9},{"name":"sdkgzrqp","size":4},{"name":"zfrwkxyq","size":8}]},{"name":"feypvukr","children":[{"name":"aczvwcpz","size":10},{"name":"dfupqnzq","size":8},{"name":"edqegnad","size":7},{"name":"mfnbnbnt","size":4},{"name":"pnrabzyg","size":4},{"name":"rudpwxuk","size":4},{"name":"udsybbac","size":3}]},{"name":"kppkamnf","children":[{"name":"edehwvcn","size":8},{"name":"ehvyurzk","size":7},{"name":"fjrwtxyc","size":6},{"name":"hbqkhwpd","size":2},{"name":"jsbrnvuj","size":5},{"name":"qhebgapz","size":7},{"name":"suzvatun","size":6},{"name":"uapkvyvz","size":7},{"name":"uefgpxxx","size":2}]}]},{"name":"pvynaxpj","children":[{"name":"axvbqkby","children":[{"name":"abczmmaq","size":7},{"name":"cszhhpcr","size":5},{"name":"ehvyurzk","size":7},{"name":"hvzhargk","size":5},{"name":"rezpxfrm","size":3},{"name":"xydqtcfs","size":3},{"name":"yxtgbkpf","size":3}]},{"name":"ckdpywhz","children":[{"name":"antebgba","size":5},{"name":"fttkrpag","size":4},{"name":"pvynaxpj","size":6},{"name":"qwyfdstq","size":9},{"name":"trkxvzja","size":8},{"name":"uapkvyvz","size":7},{"name":"vcgbndby","size":10},{"name":"xenqdxnh","size":9}]},{"name":"hsnvrsjz","children":[{"name":null,"size":1}]},{"name":"hxvkzhrs","children":[{"name":"rgphfyfe","size":3},{"name":"ybnppmdw","size":5}]},{"name":"kkvmdrjs","children":[{"name":"abczmmaq","size":7},{"name":"axvbqkby","size":8},{"name":"mtbjdznz","size":4},{"name":"rudpwxuk","size":4},{"name":"sdkgzrqp","size":4},{"name":"srdxfzym","size":2},{"name":"ynqrdgtr","size":2}]},{"name":"vmjxszcp","children":[{"name":"dnsfgbqb","size":7},{"name":"gadrappa","size":5},{"name":"keydbvcv","size":4},{"name":"qrfertxf","size":1},{"name":"ynqrdgtr","size":2},{"name":"zfrwkxyq","size":8},{"name":"zkqawbfn","size":3}]}]},{"name":"udsybbac","children":[{"name":"bsrvashe","children":[{"name":"pfcqwzhj","size":5},{"name":"pwdynhgk","size":5},{"name":"uzffyyuw","size":6}]},{"name":"efbnaxae","children":[{"name":"bnjzysqc","size":5},{"name":"cucdxuzs","size":8},{"name":"hvzhargk","size":5},{"name":"trkxvzja","size":8},{"name":"tsvugjsp","size":6},{"name":"vmjxszcp","size":8},{"name":"wcezzwsg","size":7},{"name":"xtdrxckx","size":6}]}]}]}
  end

  def node
    render json: Interest.node_matrix(params[:name])
  end

end

