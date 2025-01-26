class CreateTodoItems < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_items do |t|
      t.references :todo, null: false, foreign_key: true
      t.text :content
      t.boolean :completed

      t.timestamps
    end
  end
end
