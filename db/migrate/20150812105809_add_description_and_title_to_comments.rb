class AddDescriptionAndTitleToComments < ActiveRecord::Migration
  def change
    add_column :comments, :description, :string
    add_column :comments, :title, :string
  end
end
