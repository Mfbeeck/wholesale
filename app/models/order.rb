class Order < ActiveRecord::Base
  belongs_to :deal
  belongs_to :consumer
end
