
Pod::Spec.new do |s|

  s.name         = "CLOCommon"
  s.version      = "0.0.1"
  s.summary      = "A short description of CLOCommon."
  s.description  = <<-DESC
                    Cc
                   DESC

  s.homepage     = "https://github.com/ccloveobjc/CLOCommon"
  
  s.license      = { :type => 'Copyright', :text =>
        <<-LICENSE
        Copyright 2010-2015 CenterC Inc.
        LICENSE
    }
  
  s.author             = { "TT" => "654974034@qq.com" }
  
  s.source       = { :git => "https://github.com/ccloveobjc/CLOCommon.git", :tag => "#{s.version}" }

  # s.source_files  = "Classes", "Classes/**/*.{swift}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.default_subspec     = 'Core'



  s.subspec 'Core' do |ss|
    ss.frameworks          = "UIKit"
    ss.source_files        = "Classes/Core/**/*.{h,m,mm,hpp,cpp,c}"
    # ss.exclude_files       = "**/__tests__/*", "IntegrationTests/*"
    # ss.libraries           = "stdc++"
    # ss.pod_target_xcconfig = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14" }
  end
  s.subspec 'Json' do |ss|
    ss.frameworks          = "UIKit"
    ss.dependency            'CLOCommon/Core'
    ss.source_files        = "Classes/Json/**/*.{h,m,mm,hpp,cpp,c}"
  end
  s.subspec 'Crypt' do |ss|
    ss.frameworks          = "UIKit"
    ss.dependency            'CLOCommon/Core'
    ss.source_files        = "Classes/Crypt/**/*.{h,m,mm,hpp,cpp,c}"
  end
  # ================================== Core 分界线 =====================================================
  s.subspec 'UI' do |ss|
    ss.frameworks          = "UIKit"
    ss.dependency            'CLOCommon/Core'
    ss.source_files        = "Classes/UI/**/*.{h,m,mm,hpp,cpp,c}"
  end
  s.subspec 'WCDB' do |ss|
    ss.frameworks          = "UIKit"
    ss.dependency            'CLOCommon/Core'
    ss.dependency            'WCDB', '~>1.0'
    ss.source_files        = "Classes/WCDB/**/*.{h,m,mm,hpp,cpp,c}"
  end
end
