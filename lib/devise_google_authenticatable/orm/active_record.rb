module DeviseGoogleAuthenticator
  module Orm
    # This module contains handle schema (migrations):
    #
    #  create_table :accounts do |t|
    #    t.gauth_secret
    #    t.gauth_enabled
    #  end
    #

    module ActiveRecord
      module Schema
        include DeviseGoogleAuthenticator::Schema
      end
    end

  end
end

ActiveRecord::ConnectionAdapters::Table.send :include, DeviseGoogleAuthenticator::Orm::ActiveRecord::Schema
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, DeviseGoogleAuthenticator::Orm::ActiveRecord::Schema
