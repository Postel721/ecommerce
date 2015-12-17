class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :resource
      t.string :name

      t.timestamps null: false
    end
  end
end
