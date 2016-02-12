class Comment < ActiveRecord::Base
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :commentator, presence: true
  belongs_to :commentable, polymorphic: true
  belongs_to :commentator, polymorphic: true

  # Maximum depth can set how many children comments are permitted.
  MAX_DEPTH = -1

  after_save :bind_to_nth_parent

  class << self
    def build_from(commentable, commentator, comment_body)
      new \
      commentable: commentable,
      body: comment_body,
      commentator: commentator
    end

    def build_from_as_child_of(commentable, commentator, comment_body, parent_comment_id)
      new \
      commentable: commentable,
      body:  comment_body,
      commentator: commentator,
      parent_id: parent_comment_id
    end


    def find_commentable(commentable_str, commentable_id)
      commentable_str.constantize.find(commentable_id)
    end
  end

  # Scope to find all comments assigned to all commentable types for a given user.
  scope :find_comments_by_commentator, lambda { |commentator|
    where(commentator_id: commentator.id).order(created_at: :desc)
  }

  # Scope to find all comments for commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |type, id|
    where(commentable_type: type.to_s, commentable_id: id)
        .order(created_at: :desc)
  }

  def has_children?
    children.any?
  end

  private
  def bind_to_nth_parent
    ancestors = self.ancestors
    unless ancestors.empty? || MAX_DEPTH == -1
      parent_comment = self.ancestors[MAX_DEPTH - 1] || self.ancestors.last
      self.move_to_child_of(parent_comment)
    end
  end
end
