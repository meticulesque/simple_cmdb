class CreateCiRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_relationships do |t|
      t.references :parent, foreign_key: { to_table: :configuration_items }
      t.references :child, foreign_key: { to_table: :configuration_items }

      t.timestamps
    end
  end
end
