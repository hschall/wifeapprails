class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.date :fecha
      t.string :concepto
      t.decimal :importe
      t.string :comentario

      t.timestamps
    end
  end
end
