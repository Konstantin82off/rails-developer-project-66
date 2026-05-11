# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    record.user_id == user.id
  end

  def create?
    true
  end

  def new?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
