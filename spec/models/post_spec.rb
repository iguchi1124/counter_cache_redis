require 'rails_helper'

RSpec.describe Post do
  let!(:post) { Post.create(title: 'title', content: 'content') }
  before { post.comments.create(content: 'comment content') }

  describe '#comments_count' do
    it do
      expect(post.comments_count.to_i).to eq(post.comments.count)
    end
  end
end
