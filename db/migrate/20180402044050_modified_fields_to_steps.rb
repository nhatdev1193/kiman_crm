class ModifiedFieldsToSteps < ActiveRecord::Migration[5.1]
  def change
    rename_column :steps, :name, :display_name
    add_column :steps, :field_name, :string
  end
end
