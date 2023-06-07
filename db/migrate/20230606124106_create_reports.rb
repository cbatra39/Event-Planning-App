class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :reported_by, foreign_key: { to_table: :users }, index: true
      t.integer :reported_id
      t.integer :report_type  
      t.text :description
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
