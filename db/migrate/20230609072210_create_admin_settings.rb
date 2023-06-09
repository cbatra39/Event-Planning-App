class CreateAdminSettings < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :admin_settings do |t|
      t.hstore :settings
    end
  end
end
