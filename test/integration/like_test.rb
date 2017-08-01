require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
    @micropost = microposts(:orange)
    @post = @user.microposts.create(content: 'Lorem ipsum')
  end

  #
  # test 'should follow a user the standard way' do
  #   assert_difference '@user.following.count', 1 do
  #     post relationships_path, params: { followed_id: @other.id }
  #   end
  # end
  #
  test 'should follow a user with Ajax' do
    assert_difference '@user.liked_posts.count', 1 do
      post likes_path, xhr: true, params: {liked_post_id: @post.id}
    end
  end

  # test 'should unfollow a user the standard way' do
  #   @user.follow(@other)
  #   relationship = @user.active_relationships.find_by(followed_id: @other.id)
  #   assert_difference '@user.following.count', -1 do
  #     delete relationship_path(relationship)
  #   end
  # end

  test 'should unfollow a user with Ajax' do
    @user.like(@post)
    like = @user.likes.find_by(liked_post_id: @post.id)
    assert_difference '@user.liked_posts.count', -1 do
      delete like_path(like), xhr: true
    end
  end

end