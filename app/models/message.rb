class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :number, type: String
  field :text, type: String
  field :when, type: Time

  validates_presence_of :number, :text, :when

end