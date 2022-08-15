class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    return true if record.event.pincode.blank?
    return true if user&.author?(record.event)

    record.event.pincode_valid?(record.pincode)
  end

  def update?
    user&.author?(record)
  end

  def edit?
    update?
  end

  def destroy?
    user&.author?(record.event)
  end
end
