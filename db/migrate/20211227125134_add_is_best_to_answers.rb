class AddIsBestToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :is_best, :boolean
  end
end
