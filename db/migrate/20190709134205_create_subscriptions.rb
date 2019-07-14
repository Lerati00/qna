class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :subscribable, polymorphic: true

      t.timestamps
    end
  end
end
