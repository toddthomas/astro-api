class AddSortByToSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :searches, :sort_by, :string
  end
end
