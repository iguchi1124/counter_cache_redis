class Post < ApplicationRecord
  has_many :comments
  counter_cache :comments
end
