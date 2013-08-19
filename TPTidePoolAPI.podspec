Pod::Spec.new do |s|
  s.name         = "TPTidePoolAPI"
  s.version      = "0.0.1"
  s.summary      = "Gives access to the TidePool functionality for iOS Apps"

  s.description  = <<-DESC
                   A longer description of TPTidePoolAPI in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://alpha.tidepool.co"
  s.license      = 'MIT (example)'
  s.author       = { "Kerem Karatal" => "kkaratal@tidepool.co" }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "http://EXAMPLE/TPTidePoolAPI.git", :tag => "0.0.1" }
  s.source_files  = 'TPTidePoolAPI'
  s.frameworks = 'MobileCoreServices', 'SystemConfiguration', 'Security', 'CoreGraphics'
  s.requires_arc = true
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  s.dependency 'AFNetworking', '~> 1.3'
  s.dependency 'SSKeychain', '~> 1.2'
end
