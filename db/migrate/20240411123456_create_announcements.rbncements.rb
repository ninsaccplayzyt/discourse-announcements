class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements do |t|
      t.text :content, null: false

      t.timestamps
    end
  end
end
