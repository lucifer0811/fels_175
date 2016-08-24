class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
      if user.is_admin?
        can :manage, :all
      else
        can :read, :all
        can :update, [Result, Lesson]
        can :create, Lesson
      end
  end
end
