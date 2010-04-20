class AddDescriptionToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :description, :text
  end

  def self.down
    remove_column :hosts, :description
  end
end
