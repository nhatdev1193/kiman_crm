class RemoveContractKind < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :contracts, :contract_kinds
    remove_column :contracts, :contract_kind_id
    remove_foreign_key :forms, :contract_kinds
    remove_column :forms, :contract_kind_id
    drop_table :contract_kinds, force: :cascade
  end
end
