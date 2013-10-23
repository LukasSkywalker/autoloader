require "autoloader/version"
require "autoloader/resource_loader"

module Autoloader
    module ControllerAdditions
        def autoload_resource(*args)
            name = args.first
            klass = Kernel.const_get(name.to_s.classify)
            
            opts = {
                :scope => klass,
                :identifier => :id
            }.merge(args.extract_options! || {})
            
            self.send(:append_before_filter, opts.slice(:except, :only)) do |controller|
                rl = ResourceLoader.new(controller.action_name, params, opts)
                instance_variable_set(('@'+name.to_s).to_sym, rl.load_resource)
            end
        end
    end
end

ActionController::Base.class_eval do
    extend Autoloader::ControllerAdditions
end
