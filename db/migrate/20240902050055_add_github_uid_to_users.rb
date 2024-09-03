class AddGithubUidToUsers < ActiveRecord::Migration[7.1]
  def change
    # add_column :users, :github_uid, :string, null: false, default: '0'
    # User.find_by(name: 'Aleksandr Istomin')&.update(github_uid: '48231479')
    # User.find_by(name: 'Vasilisa')&.update(github_uid: '14819968')
  end
end
