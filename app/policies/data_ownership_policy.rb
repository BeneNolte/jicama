class DataOwnershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    record.user == user
  end

  def update?
    record.datasource.user == user
  end

end
