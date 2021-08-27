#
# Be sure to run `pod lib lint ERPINCodeViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ERPINCodeViewController'
  s.version          = '1.0.5'
  s.summary          = 'Easy PIN Code generation, changing, and verifying via Keychain.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'ERPINCodeViewController makes it easy to prompt users to generate a client-side PIN code, request verification using a simple API. ERPINCodeViewController takes care of UI associated with creating, changing, and verifying PIN codes while storing data securly in the Keychain.'

  s.homepage         = 'https://github.com/erusso1/ERPINCodeViewController.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erusso1' => 'ephraim.s.russo@gmail.com' }
  s.source           = { :git => 'https://github.com/erusso1/ERPINCodeViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'ERPINCodeViewController/Classes/**/*'
  s.dependency 'KeychainAccess'
  s.dependency 'CryptoSwift', '~> 1.4.1'

  s.resource_bundles = {
    'ERPINCodeViewController_Resources' => ['ERPINCodeViewController/Assets/*']
  }

end
