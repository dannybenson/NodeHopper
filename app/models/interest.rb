class Interest

  def self.get_interest_names(label = "Interest")
    @neo = ClientHelper.get_client
    @neo.get_nodes_labeled(label).map{ |labeled|  @neo.get_node_properties(labeled, 'name')["name"] }
  end

  def self.find_or_create_by(label, name)
    @neo = ClientHelper.get_client
    if @neo.find_nodes_labeled(label, {:name => name}).empty?
      node = @neo.create_node("name" => name)
      @neo.add_label(node, ["Interest", label])
      node
    else
      @neo.find_nodes_labeled(label, {:name => name}).first
    end
  end

end
