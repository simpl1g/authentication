class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :password
      t.string :email
      t.boolean :two_step_auth

      t.timestamps
    end
  end
end
