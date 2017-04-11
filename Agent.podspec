Pod::Spec.new do |s|
  s.name                  = "Agent"
  s.summary               = "Minimalistic Swift HTTP request agent for iOS and OS X"
  s.version               = "0.1.0"
  s.homepage              = "https://github.com/hallas/agent"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "hallas" => "christoffer.hallas@gmail.com" }
  s.source                = { :git => "https://github.com/hallas/agent.git", :tag => "#{s.version}" }
  s.source_files          = "Agent/Agent.swift"
  s.requires_arc          = true
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
end
