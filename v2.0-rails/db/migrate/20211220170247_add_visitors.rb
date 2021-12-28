class AddVisitors < ActiveRecord::Migration[7.0]
  def change
    create_table :visitors, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.timestamps
    end
  end
end
