class FacebookConfig
  def self.[](key)
#    puts "LOOKING UP #{key}"
    case key
      when "app_id" then "123456"
      when "auth_path" then "/login"
    end
  end
end
