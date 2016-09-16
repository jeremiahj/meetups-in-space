class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |c|
      c.string  :name, null: false, uniqueness: true
      c.text    :detail, null: false
      c.text    :location, null: false
      c.belongs_to :user, null: false

      c.timestamps null: false
    end
  end
end
