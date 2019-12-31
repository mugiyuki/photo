class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.references :user, foreign_key: true
      t.references :follow_user, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
