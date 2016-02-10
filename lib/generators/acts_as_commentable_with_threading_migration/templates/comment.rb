class Comment < ActiveRecord::Base
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :commentator, presence: true
  belongs_to :commentable, polymorphic: true
  belongs_to :commentator, polymorphic: true

  # Maximum depth can set how many children comments are permitted.
  # Defaults to "unbound".
  MAX_DEPTH=-1

  after_save :bind_to_nth_parent

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

  def self.build_from(commentable, commentator, comment_body)
    new \
      commentable: commentable,
      body: comment_body,
      commentator: commentator
  end

  def self.build_as_child_of(commentable, commentator, comment_body, parent_comment)
    new \
      commentable: commentable,
      body:  comment_body,
      commentator: commentator,
      parent_id: parent_comment.id
  end

  def has_children?
    children.any?
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  private
  def bind_to_nth_parent
    ancestors = self.ancestors

  end
end
