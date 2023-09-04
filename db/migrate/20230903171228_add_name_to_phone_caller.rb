class AddNameToPhoneCaller < ActiveRecord::Migration[7.0]
  def change
    add_column :phone_callers, :name, :string
  end
end
