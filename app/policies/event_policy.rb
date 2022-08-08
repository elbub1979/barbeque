class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    true
  end

  def update?
    user&.author?(record)
  end

  def edit?
    update?
  end

  def destroy?
    user&.author?(record)
  end
end
