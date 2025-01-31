class CreateConfigurationItems < ActiveRecord::Migration[8.0]
  def change
    create_table :configuration_items do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :status, null: false
      t.string :environment, null: false

      t.timestamps
    end
  end
end
