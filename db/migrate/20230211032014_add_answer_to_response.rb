class AddAnswerToResponse < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :answer, :text
  end
end
