class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.integer :generated_code
      t.references :user

      t.timestamps
    end
    add_index :codes, [:generated_code, :user_id]
  end
end
