class AddLocationToEvent < ActiveRecord::Migration
  def change
    add_column :events, :regroup_location, :string
    add_column :events, :finish_line, :string
  end
end
