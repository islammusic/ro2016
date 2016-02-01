class AddUserToDestination < ActiveRecord::Migration
  def change
    add_reference :destinations, :user, index: true, foreign_key: true
  end
end
