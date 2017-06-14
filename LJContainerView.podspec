
Pod::Spec.new do |s|
  s.name         = "LJContainerView"
  s.version      = "1.0.0"
  s.summary      = "多个视图控制器(tableview)切换页框架"
  s.description  = <<-DESC
  多个视图控制器(tableview)切换页框架,使用时内部子视图控制器需要继承LJBaseContainerViewController
                   DESC

  s.homepage     = "https://github.com/ChatCoding/LJContainerView"

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  
  s.author             = { "领琾" => "825238111@qq.com" }  
  
  s.platform     = :ios, '7.0'  
  # s.ios.deployment_target = '7.0'  
  # s.osx.deployment_target = '10.11'  
  s.requires_arc = true  
  s.source           = { :git => "https://github.com/ChatCoding/LJContainerView.git", :tag => s.version.to_s }  
  s.source_files = "LJContainerView/*"
  
  s.frameworks = "Foundation", "UIKit"

end
