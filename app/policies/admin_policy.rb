# frozen_string_literal: true

class AdminPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def permit?
    user&.admin?
  end
end
