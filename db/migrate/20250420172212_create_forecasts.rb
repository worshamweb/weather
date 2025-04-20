class CreateForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :forecasts do |t|
      t.string :zip_code, null: false
      t.text :forecast, null: false

      t.timestamps
    end
    add_index :forecasts, :zip_code, unique: true
  end
end

