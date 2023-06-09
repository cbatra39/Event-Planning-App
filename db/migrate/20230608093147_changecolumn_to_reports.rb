class ChangecolumnToReports < ActiveRecord::Migration[7.0]
  def change
    remove_column :reports, :status
  end
end
