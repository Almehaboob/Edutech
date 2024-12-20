class AddRowOrderToLesson < ActiveRecord::Migration[7.2]
  def change
    add_column :lessons, :row_order, :integer
  end
end
