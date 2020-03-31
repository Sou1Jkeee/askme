class AddBgcolorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bgcolor, :string, default: '#005a55'
  end
end
