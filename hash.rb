# frozen_string_literal: true

class HashMap
  INITIAL_BUCKET_COUNT = 16
  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(INITIAL_BUCKET_COUNT) { [] }
    @size = 0
  end

  def hash(key)
    key.hash % @buckets.size
  end

  def set(key, value)
    resize if load_factor_exceeded?

    bucket_index = hash(key)
    bucket = @buckets[bucket_index]

    pair = bucket.find { |item| item[0] == key }
    if pair
      pair[1] = value
    else
      bucket << [key, value]
      @size += 1
    end
  end

  def get(key)
    bucket_index = hash(key)
    bucket = @buckets[bucket_index]

    pair = bucket.find { |item| item[0] == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    bucket_index = hash(key)
    bucket = @buckets[bucket_index]

    bucket.any? { |item| item[0] == key }
  end

  def remove(key)
    bucket_index = hash(key)
    bucket = @buckets[bucket_index]

    pair = bucket.find { |item| item[0] == key }
    if pair
      bucket.delete(pair)
      @size -= 1
      pair[1]
    else
      nil
    end
  end

  def length
    @size
  end

  def clear
    @buckets = Array.new(INITIAL_BUCKET_COUNT) { [] }
    @size = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map { |item| item[0] } }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map { |item| item[1] } }
  end

  def entries
    @buckets.flat_map { |bucket| bucket.map { |item| item } }
  end

  private

  def load_factor_exceeded?
    @size >= @buckets.size * LOAD_FACTOR
  end

  def resize
    old_buckets = @buckets
    @buckets = Array.new(@buckets.size * 2) { [] }
    @size = 0

    old_buckets.flatten(1).each do |key, value|
      set(key, value)
    end
  end
end
