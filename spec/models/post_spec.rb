require 'rails_helper'

RSpec.describe Post do
  let!(:post) { Post.create(title: 'title', content: 'content') }

  before do
    post.comments.create(content: 'comment content 1')
    post.comments.create(content: 'comment content 2')
  end

  describe '#comments_count' do
    it do
      expect(post.comments_count).to eq(post.comments.count)
    end

    it 'increment comments count' do
      expect {
        post.comments.create(content: 'new comment content')
      }.to change {
        post.comments_count
      }.by(1)
    end

    it 'decrement comments count' do
      expect {
        post.comments.last.destroy
      }.to change {
        post.comments_count
      }.by(-1)
    end
  end
end
