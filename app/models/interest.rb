class Interest

  def self.get_interest_names(label = "Interest")
    @neo = ClientHelper.get_client
    @neo.get_nodes_labeled(label).map{ |labeled|  @neo.get_node_properties(labeled, 'name')["name"] }
  end
end
