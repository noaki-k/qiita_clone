class CreateUserDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :user_details do |t|
      t.string :avatar
      t.string :sns_account
      t.text :introduction
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
