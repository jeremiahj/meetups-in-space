class CreateUsermeetups < ActiveRecord::Migration
  def change
    create_table :usermeetups do |c|
      c.belongs_to :user, null: false
      c.belongs_to :meetup, null: false
    end
  end
end
