class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :degree, null: false, default: 1
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
