class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :token
      t.string :event_action
      t.string :event_description
      t.string :event_scope

      t.timestamps
    end
  end
end
