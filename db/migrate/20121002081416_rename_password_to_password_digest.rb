class RenamePasswordToPasswordDigest < ActiveRecord::Migration
  def self.up
    rename_column :users, :password, :password_digest
  end

  def self.down
    rename_column :users, :password_digest, :password
  end
end
