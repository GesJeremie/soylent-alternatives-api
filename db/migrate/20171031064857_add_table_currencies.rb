class AddTableCurrencies < ActiveRecord::Migration[5.1]
  def up
    create_table :currencies do |t|
      t.string :base
      t.text :response
      t.timestamps
    end
  end

  def down
    drop_table :currencies
  end
end
