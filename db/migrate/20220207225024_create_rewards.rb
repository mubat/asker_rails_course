class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.references :rewardable, polymorphic: true

      t.timestamps
    end
  end
end
