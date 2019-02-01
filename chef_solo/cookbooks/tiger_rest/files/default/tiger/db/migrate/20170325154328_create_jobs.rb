class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.integer :testID
      t.text :DockerHostID
      t.text :sid
      t.datetime :created_at
      t.datetime :updated_at
      t.text :result
      t.text :details
      t.text :tags
      t.text :links

      t.timestamps
    end
  end
end
