class CreateMutations < ActiveRecord::Migration[7.1]
  def change
    create_table :mutations do |t|
      t.string    :receiver_type
      t.integer   :receiver_id
      t.string    :sender_type
      t.integer   :sender_id
      t.integer   :nominal
      t.string    :note

      t.timestamps
    end

    add_index :mutations, [:receiver_id, :receiver_type]
    add_index :mutations, [:sender_id, :sender_type]
  end
end
