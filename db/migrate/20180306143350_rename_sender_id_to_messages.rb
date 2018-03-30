class RenameSenderIdToMessages < ActiveRecord::Migration[5.1]
  def change
    rename_column :messages, :sender_id, :user_id
  end
end
