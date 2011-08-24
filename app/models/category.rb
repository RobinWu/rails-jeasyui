class Category < ActiveRecord::Base
  acts_as_tree :order => 'name'

  def to_tree_node_hash
    return  {:id => self.id, :text => self.name} if self.children.empty?
    {:id => self.id, :text => self.name, :children => self.children.map{|i| i.to_tree_node_hash}}
  end

  def to_tree_json
    self.to_tree_node_hash.to_json
  end

  def self.to_tree_json
    Category.roots.map{|r| r.to_tree_node_hash}.to_json
  end
end
