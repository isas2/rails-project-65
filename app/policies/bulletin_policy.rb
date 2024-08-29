# frozen_string_literal: true

class BulletinPolicy
  attr_reader :user, :bulletin

  def initialize(user, bulletin)
    @user = user
    @bulletin = bulletin
  end

  def index?
    true
  end

  def show?
    bulletin.published? || bulletin.user == user || user&.admin?
  end

  def create?
    user
  end

  def profile?
    user
  end

  def new?
    create?
  end

  def update?
    bulletin.user == user
  end

  def edit?
    update?
  end

  def to_moderate?
    update?
  end

  def archive?
    update?
  end
end
