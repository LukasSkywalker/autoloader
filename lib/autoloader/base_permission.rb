module Autoloader
  class BasePermission
    def self.allow(*actions)
      actions.each do |action|
        self.send(:define_method, action) do |user, record|
          true
        end
      end
    end

    def index(user, scope)
      false
    end

    def show(user, record)
      false
    end

    def new(user, record)
      false
    end

    def create(user, record)
      false
    end

    def edit(user, record)
      false
    end

    def update(user, record)
      false
    end

    def destroy(user, record)
      false
    end
  end
end
