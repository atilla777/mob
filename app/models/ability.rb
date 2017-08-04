class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    not_anonymouse = true if user.present?
    alias_action :create, :read, :update, :destroy, to: :crud
    user ||= User.new
    if user.admin?
      can :crud, :all
      cannot :crud, Vote, post: { user_id: user.id } # admin can`t manage votes for his post
    elsif user.writer?
      can :crud, Post, user_id: user.id # writer can manage his posts
      can :crud, Comment, user_id: user.id # writer can manage his comments
      can :crud, Vote, user_id: user.id # writer can manage his votes
      cannot :crud, Vote, post: { user_id: user.id } # writer can`t manage votes for his post
    elsif not_anonymouse
      can :read, Post, user_id: user.id # user can read posts
      can :crud, Comment, user_id: user.id # user can manage his comments
      can :crud, Vote, user_id: user.id # user can manage his votes
      cannot :crud, Vote, post: { user_id: user.id } #user can`t manage votes for his post
    else
      can :read, Post
    end
  end
end
