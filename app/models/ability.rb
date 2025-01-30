class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new  # Guest user

    if user.has_role?(:admin)
      can :manage, :all  # Admin can do everything
    elsif user.has_role?(:viewer)
      can :read, :all  # Viewer can only read
    end
  end
end
