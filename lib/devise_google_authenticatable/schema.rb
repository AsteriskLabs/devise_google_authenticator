module DeviseGoogleAuthenticator
  # add schema helper for migrations
  module Schema
    # Add gauth_secret columns in the resource's database tables
    #
    # Examples
    #
    # # For a new resource migration:
    # create_table :the_resources do |t|
    #   t.gauth_secret
    #   t.gauth_enabled
    # ...
    # end
    #
    # # or if the resource's table already exists, define a migration and put this in:
    # change_table :the_resources do |t|
    #   t.string :gauth_secret
    #   t.boolean :gauth_enabled
    # end
    #
    def gauth_secret
      apply_devise_schema :gauth_secret, String
    end
    
    def gauth_enabled
      apply_devise_schema :gauth_enabled, Integer, {:default => 0}
    end

    def gauth_tmp
        apply_devise_schema :gauth_tmp, String
    end

    def gauth_tmp_datetime
        apply_devise_schema :gauth_tmp_datetime, Datetime
    end

  end
end
