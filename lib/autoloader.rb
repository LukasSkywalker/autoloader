require "autoloader/version"
require "autoloader/resource_loader"

module Autoloader
    module ControllerAdditions
        def autoload_resource(*args)
            name = args.first
            klass = Kernel.const_get(name.to_s.classify)
            
            opts = {
                :scope => Proc.new { klass },
                :identifier => :id
            }.merge(args.extract_options! || {})
            
            self.send(:append_before_filter, opts.slice(:except, :only)) do |controller|
                scp = instance_exec(&opts[:scope])
                rl = ResourceLoader.new(controller, params, opts, scp)
                name = name.to_s.pluralize if controller.action_name == 'index'
                Rails.logger.info('Assigning @' + name.to_s)
                instance_variable_set(('@'+name.to_s).to_sym, rl.load_resource)
            end
        end
    end
end

ActionController::Base.class_eval do
    extend Autoloader::ControllerAdditions
end
