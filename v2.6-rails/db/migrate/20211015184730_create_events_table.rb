class CreateEventsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :visits, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.datetime :visited_at, null: false
      t.string :visitor_id, null: false
      t.string :page_path, null: false
    end

    add_index :visits, 'visited_at DESC'
  end
end
