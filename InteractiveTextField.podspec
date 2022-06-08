Pod::Spec.new do |spec|
    spec.name          = 'InteractiveTextField'
    spec.version       = '1.0.2'
    spec.license       = { :type => 'MIT', :file => 'LICENSE.md' }
    spec.homepage      = 'https://github.com/sengthaite/InteractiveTextField'
    spec.authors       = { 'Sengthai Te' => 'sengthaite@gmail.com' }
    spec.summary       = 'A customized textfield'
    spec.source        = { :git => 'https://github.com/sengthaite/InteractiveTextField.git', :tag => 'v1.0.2' }
    spec.module_name   = 'InteractiveTextField'
    spec.swift_version = '5.6'
  
    spec.ios.deployment_target  = '12.0'
  
    spec.source_files       = 'Sources/InteractiveTextField/*.swift'
  end
