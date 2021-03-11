#
# Be sure to run `pod lib lint TWTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TWTool'
  s.version          = '0.0.16'
  s.summary          = 'TWTool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'twTooltwTool'

  s.homepage         = 'https://github.com/tanwang11/TWTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tanwang11' => 'aihy@linrunwc.com' }
  s.source           = { :git => 'https://github.com/tanwang11/TWTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TWTool/Classes/TWTool.h'
  
  # s.resource_bundles = {
  #   'TWTool' => ['TWTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.frameworks = 'UIKit', 'Foundation', 'CoreText'
  
  
  # 创建文件夹
  s.subspec 'TWTest1' do |ss|
#    ss.source_files = 'TWTool/Classes/TWTest1/*.{h,m}'
    ss.source_files = 'TWTool/Classes/TWTest1/*'
  end

  # 创建文件夹
  s.subspec 'TWFoundation' do |ss|
    ss.source_files = 'TWTool/Classes/TWFoundation/TWFoundation.h'
    
    
    ss.subspec 'NSArray' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.dependency  'TWTool/TWFoundation/Prefix'
        sss.source_files = 'TWTool/Classes/TWFoundation/NSArray/*.{h,m}'
    end
    
    
    ss.subspec 'TWAssistant' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/Prefix'
        sss.source_files = 'TWTool/Classes/TWFoundation/TWAssistant/*.{h,m}'
    end
    
    
    ss.subspec 'NSData' do |sss|
        sss.source_files = 'TWTool/Classes/TWFoundation/NSData/*.{h,m}'
    end
    
    
    ss.subspec 'NSDate' do |sss|
        # 需要引入的其他文件的的 .h 文件 
        sss.dependency  'TWTool/TWFoundation/NSString'
        sss.source_files = 'TWTool/Classes/TWFoundation/NSDate/*.{h,m}'
    end
    
    
    ss.subspec 'NSDecimalNumber' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.source_files = 'TWTool/Classes/TWFoundation/NSDecimalNumber/*.{h,m}'
    end
    
    
    ss.subspec 'NSDictionary' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.dependency  'TWTool/TWFoundation/Prefix'
        sss.source_files = 'TWTool/Classes/TWFoundation/NSDictionary/*.{h,m}'
    end
    
    
    ss.subspec 'NSFileManager' do |sss|
        sss.source_files = 'TWTool/Classes/TWFoundation/NSFileManager/*.{h,m}'
    end
    
    
    ss.subspec 'NSObject' do |sss|
        sss.source_files = 'TWTool/Classes/TWFoundation/NSObject/*.{h,m}'
    end
    
    
    ss.subspec 'NSString' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.dependency  'TWTool/TWFoundation/Prefix'
        
        sss.source_files = 'TWTool/Classes/TWFoundation/NSString/*.{h,m}'
    end
    
    
    ss.subspec 'Prefix' do |sss|
        sss.source_files = 'TWTool/Classes/TWFoundation/Prefix/*.{h,m}'
    end
    
  end
  
  # 创建文件夹
  s.subspec 'TWDatePicker' do |ss|
#    ss.source_files = 'TWTool/Classes/TWTest1/*.{h,m}'
    ss.source_files = 'TWTool/Classes/TWDatePicker/*'
  end
  
  
  s.subspec 'TWUI' do |ss|
    ss.source_files = 'TWTool/Classes/TWUI/*'
    
    ss.subspec 'UIViewController' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.dependency  'TWTool/TWFoundation/Prefix'
        sss.dependency  'TWTool/TWFoundation/NSString'
        sss.source_files = 'TWTool/Classes/TWUI/UIViewController/*.{h,m}'
    end
    
    ss.subspec 'UIView' do |sss|
        sss.source_files = 'TWTool/Classes/TWUI/UIView/*.{h,m}'
    end
    
    ss.subspec 'UITextView' do |sss|
        sss.source_files = 'TWTool/Classes/TWUI/UITextView/*.{h,m}'
    end
    
    ss.subspec 'UITextField' do |sss|
        # 需要引入的其他文件的的 .h 文件
        sss.dependency  'TWTool/TWFoundation/NSObject'
        sss.dependency  'TWTool/TWFoundation/NSString'
        sss.source_files = 'TWTool/Classes/TWUI/UITextField/*.{h,m}'
    end
    
  end
  
  
end
