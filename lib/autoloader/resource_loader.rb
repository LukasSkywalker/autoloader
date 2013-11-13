module Autoloader
  class ResourceLoader
    def initialize(controller, params, opts, scope)
      @controller = controller
      @params = params
      @opts = opts
      @klass = scope
      @model_params = params[@klass.name.underscore.to_sym]
      @user = controller.instance_exec(&opts[:user_method])
      @permission = opts[:permission]
    end

    def load_resource
      if singular?
        load_resource_instance
      else
        load_collection
      end
      Autoloader::PermissionFinder.search(@klass, action_name.to_sym, @user, @resource, self.plural?, @permission)
    end

    def singular?
      new_actions.include?(action_name.to_sym) || identifier
    end

    def plural?
      !self.singular?
    end

    protected

    def action_name
      @controller.action_name
    end

    def identifier
      @params[@opts[:identifier]]
    end

    def collection_actions
      [:index]
    end

    def new_actions
      [:new, :create]
    end

    def load_resource_instance
      if new_actions.include?(action_name.to_sym)
        build_resource
      elsif identifier
        find_resource
        update_resource if action_name == 'update'
      end
    end

    def update_resource
      @resource.assign_attributes(@model_params)
    end

    def load_collection
      @resource = @klass
    end

    def build_resource
      @resource = @klass.new(@model_params || {})
    end

    def find_resource
      @resource = @klass.find(identifier)
    end
  end
end
