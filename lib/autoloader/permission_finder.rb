module Autoloader
  class PermissionFinder
    def self.search(klass, action, user, record, plural, permission)
      permission_name = klass.name + 'Permission'
      if self.class_exists?(permission_name.to_s)
        permission ||= Kernel.const_get(permission_name.to_s)
      else
        raise MissingPermission.new('No permission found for ' + klass.name)
      end

      if permission.new.respond_to?(action.to_sym)
        result = permission.new.send(action.to_sym, user, record)
      else
        raise MissingAction.new('Permission for action ' + action.to_s + ' could not be found in ' + permission_name)
      end

      if result
        if plural
          return result
        else
          return record
        end
      else
        raise PermissionDenied.new('Permission for action ' + action.to_s + ' was denied by ' + permission_name)
      end
    end

    def self.class_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end
  end

  class PermissionError < StandardError; end
  class MissingAction < PermissionError; end
  class MissingPermission < PermissionError; end
  class PermissionDenied < PermissionError; end
end
