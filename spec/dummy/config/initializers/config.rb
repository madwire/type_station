TypeStation.configure do |config|

  # config.authenticate_with = Proc.new do
  #   request.env['warden'].try(:authenticate!)
  # end

  # config.authorise_with = Proc.new {}

  # config.current_user = Proc.new do
  #   request.env["warden"].try(:user) || respond_to?(:current_user) && current_user
  # end

  config.authenticate_with = Proc.new do
    true
  end

  config.authorise_with = Proc.new { true }

  config.current_user = Proc.new do
    Struct.new(:email).new("rich@madwire.co.uk")
  end

end
