require 'test_helper'

class LikeController < ActiveSupport::TestCase
  def setup
    @like = Like.new(liked_user_id: users(:michael).id, liked_post_id: users(:archer).microposts.first.id)
  end

  test 'should be valid' do
    assert @like.valid?
  end
  test 'should require a liked_user_id' do
    @like.liked_user_id = nil
    assert_not @like.valid?
  end
  test 'should require a liked_post_id' do
    @like.liked_post_id = nil
    assert_not @like.valid?
  end
end