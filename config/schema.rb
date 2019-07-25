require_relative './boot.rb'

DB.drop_table(:tweets) if DB.table_exists?(:tweets) && ENV["FORCE"]
DB.create_table :tweets do
  column :id, String, primary_key: true
  column :created_at, DateTime, index: true
  column :tweet, :json
end
