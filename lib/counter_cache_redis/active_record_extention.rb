# frozen_string_literal: true
module CounterCacheRedis
  module ActiveRecordExtention
    extend ActiveSupport::Concern

    included do
      def self.counter_cache(tableized_model, redis = Redis.current)
        class_name = self.to_s.downcase
        child_model_class = eval tableized_model.to_s.classify
        tableized_child_model = tableized_model.to_sym
        primary_key = self.primary_key.to_sym

        define_method "#{tableized_child_model}_count" do
          count = redis.get(_counter_cache_key(class_name, primary_key, tableized_child_model))

          if count.nil?
            count = self.send(tableized_child_model).count
            redis.set(
              self._counter_cache_key(class_name, primary_key, tableized_child_model),
              count
            )
          end

          count.to_i
        end

        define_method "_#{tableized_child_model}_count_incr" do
          redis.incr(_counter_cache_key(class_name, primary_key, tableized_child_model))
        end

        define_method "_#{tableized_child_model}_count_decr" do
          redis.decr(_counter_cache_key(class_name, primary_key, tableized_child_model))
        end

        after_create do
          redis.set(
            self._counter_cache_key(class_name, primary_key, tableized_child_model),
            self.send(tableized_child_model).count
          )
        end

        child_model_class.class_eval do
          after_create do
            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_incr")
          end

          after_destroy do
            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_decr")
          end
        end
      end

      def _counter_cache_key(class_name, primary_key, tableized_child_model)
        '_' + [class_name, self.send(primary_key), tableized_child_model].join('_')
      end
    end
  end
end
