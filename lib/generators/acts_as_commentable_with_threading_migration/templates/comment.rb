class Comment < ActiveRecord::Base
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :commentator, presence: true
  belongs_to :commentable, polymorphic: true
  belongs_to :commentator, polymorphic: true

  # Scope to find all comments assigned to all commentable types for a given user.
  scope :find_comments_by_commentator, lambda { |commentator|
    where(commentator_id: commentator.id).order(created_at: :desc)
  }

  # Scope to find all comments for commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |type, id|
    where(commentable_type: type.to_s, commentable_id: id)
        .order(created_at: :desc)
  }

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a commentator, and comment text

  def self.build_from(commentable, commentator, comment)
    new \
      commentable: commentable,
      body: comment,
      commentator: commentator
  end

  def has_children?
    children.any?
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end
