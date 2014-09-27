require 'ostruct'
require 'byebug'
require 'nokogiri'
require 'csv'
require 'tabloid'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :addresses, :force => true do |t|
    t.string :street
    t.string :city
    t.string :state
    t.string :zip
    t.timestamps
  end
end

class Address < ActiveRecord::Base

end
