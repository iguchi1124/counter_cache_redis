# frozen_string_literal: true
module CounterCacheRedis
  class Railtie < ::Rails::Railtie
    initializer 'counter_cache_redis' do
      ActiveSupport.on_load(:active_record) do
        require 'counter_cache_redis/active_record_extention'
        ::ActiveRecord::Base.send :include, ActiveRecordExtention
      end
    end
  end
end
