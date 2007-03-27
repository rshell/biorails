class Project::BaseController < ApplicationController
  class_inheritable_reader :member_actions
  write_inheritable_attribute :member_actions, []

  protected
    # standard authorization method.  allow logged in users that are admins, or members in certain actions
    def authorized?
      logged_in? && (admin? || member_actions.include?(action_name) || allow_member?)
    end

    # further customize the authorization process, for those special methods that require extra validation
    def allow_member?
      true
    end


end
