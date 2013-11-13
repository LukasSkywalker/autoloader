module Autoloader
  class BasePermission
    attr_accessor :user, :record, :guest, :action

    def initialize(user, action, record)
      @user = user
      @record = record
      @guest = user.nil?
      @action = action
    end

    def find
      if guest
        guest_method = 'guest_' + action.to_s
        if self.respond_to? guest_method
          self.send(guest_method)
        else
          false
        end
      else
        self.send(action)
      end
    end

    def defined?
      Rails.logger.warn(guest)
      if guest
        guest_method = 'guest_' + action.to_s
        return self.respond_to? guest_method
      else
        self.respond_to? action
      end
    end

    def self.allow(*actions)
      actions.each do |action|
        self.send(:define_method, action) do
          true
        end
      end
    end

    def self.guest(*actions)
      actions.each do |action|
        self.send(:define_method, 'guest_' + action.to_s) do
          true
        end
      end
    end

    def index
      false
    end

    def show
      false
    end

    def new
      false
    end

    def create
      false
    end

    def edit
      false
    end

    def update
      false
    end

    def destroy
      false
    end
  end
end
