ActiveRecord::Schema.define(version: 1) do
  create_table 'users', force: true, &:timestamps

  create_table 'commentables', force: true, &:timestamps

  create_table :comments, force: true do |t|
    t.integer :commentable_id
    t.string :commentable_type
    t.string :title
    t.text :body
    t.string :subject
    t.string :commentator_type, null: false
    t.integer :commentator_id, null: false
    t.integer :parent_id, :lft, :rgt
    t.timestamps null: false
  end

  add_index :comments, :commentator_id
  add_index :comments, [:commentable_id, :commentable_type]
end
