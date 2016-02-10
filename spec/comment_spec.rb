require File.expand_path('./spec_helper', File.dirname(__FILE__))

describe Comment do
  let(:user) {
    User.create!
  }

  let(:comment) {
    Comment.create!(body: 'Root comment', commentator: user)
  }

  it 'should have a commentator' do
    expect(comment.commentator).not_to be_nil
  end

  it 'should have a body' do
    expect(comment.body).not_to be_nil
  end

  it 'should not have a parent if it is a root Comment' do
    expect(comment.parent).to be_nil
  end

  it 'can have see how child Comments it has' do
    expect(comment.children.size).to eq(0)
  end

  context 'when adding child comments' do
    let(:grandchild) {
      grandchild = Comment.new(body: 'This is a grandchild', commentator: user)
      grandchild.save!
      grandchild
    }

    before(:each) do
      grandchild.move_to_child_of(comment)
    end

    it 'successfully adds one' do
      expect(comment.children.size).to eq 1
    end
  end

  describe 'after having a child added' do
    let(:child) {
      Comment.create!(body: 'Child comment', commentator: user)
    }

    before(:each) do
      child.move_to_child_of(comment)
    end

    it 'can be referenced by its child' do
      expect(child.parent).to eq(comment)
    end

    it 'can see its child' do
      expect(comment.children.first).to eq(child)
    end
  end

  describe 'finders' do
    describe '#find_comments_by_user' do
      let(:other_user) {
        User.create!
      }

      let(:user_comment) {
        Comment.create!(body: 'Child comment', commentator: user)
      }

      let(:non_user_comment) {
        Comment.create!(body: 'Child comment', commentator: other_user)
      }

      let(:comments) {
        Comment.find_comments_by_commentator(user)
      }

      it 'should return all the comments created by the passed user' do
        expect(comments).to include(user_comment)
      end

      it 'should not return comments created by non-passed users' do
        expect(comments).not_to include(non_user_comment)
      end
    end

    describe '#find_comments_for_commentable' do
      let(:other_user) {
        User.create!
      }

      let(:user_comment) {
        Comment.create!(body: 'from user',
                        commentable_type: other_user.class.to_s,
                        commentable_id: other_user.id,
                        commentator: user)
      }

      let(:other_comment) {
        Comment.create!(body: 'from other user',
                        commentable_type: user.class.to_s,
                        commentable_id: user.id,
                        commentator: other_user)
      }

      let(:comments) {
        Comment.find_comments_for_commentable(other_user.class,
                                              other_user.id)
      }

      it 'should return the comments for the passed commentable' do
        expect(comments).to include(user_comment)
      end

      it 'should not return the comments for non-passed commentables' do
        expect(comments).not_to include(other_comment)
      end
    end
  end
end
