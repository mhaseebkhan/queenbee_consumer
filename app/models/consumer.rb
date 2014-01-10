class Consumer < ActiveRecord::Base

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :token, :event_action, :event_description, :event_scope
end
