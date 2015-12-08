class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :ja
      t.string :vn
      t.references :lesson, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
