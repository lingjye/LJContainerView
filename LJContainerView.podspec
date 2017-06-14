
Pod::Spec.new do |s|
  s.name         = 'LJContainerView'
  s.version      = '1.0.0'
  s.summary      = '多个视图控制器(tableview)切换页框架"'
  s.description  = <<-DESC
  多个视图控制器(tableview)切换页框架,使用时内部子视图控制器需要继承LJBaseContainerViewController
                   DESC
  s.homepage     = 'ttps://github.com/ChatCoding/LJContainerView'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { '领琾' => '825238111@qq.com' }
  s.source       = { :git => 'https://github.com/ChatCoding/LJContainerView.git', :tag => s.version.to_s }
  s.platforms    = { :ios => "7.0"}
  s.requires_arc = true
  
  s.ios.source_files         = 'LJContainerView/*.{h,m}'
  s.osx.source_files         = 'LJContainerView/*.{h,m}'
  s.frameworks       = 'UIKit'

end
