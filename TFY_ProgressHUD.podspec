

Pod::Spec.new do |spec|
  spec.name         = "TFY_ProgressHUD"
  spec.version      = "2.2.0"
  spec.summary      = "完美提示框，使用各种场合"
  spec.description  = "完美提示框，使用各种场合"

  spec.homepage     = "https://github.com/13662049573/TFY_ProgressHUD"
  
  spec.license      = "MIT"
  
  spec.author             = { "tianfengyou" => "420144542@qq.com" }
  
  spec.platform     = :ios
  

  spec.source       = { :git => "https://github.com/13662049573/TFY_ProgressHUD.git", :tag => spec.version }



  spec.source_files  = "TFY_ProgressHUD/TFY_ProgressHUD/**/*.{h,m}"
  
  spec.resources = "TFY_ProgressHUD/TFY_ProgressHUD/TFY_ProgressHUD.bundle"


  spec.frameworks = "AvailabilityMacros","QuartzCore"

  
  spec.requires_arc = true

end
