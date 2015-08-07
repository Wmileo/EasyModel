Pod::Spec.new do |s|
  s.name         = "EasyModel"
  s.version      = "0.0.3"
  s.summary      = "EasyModel : AIProperty ,BaseModel"
  s.description  = <<-DESC
					 Include AIProperty and BaseModel
					 Easy to get property value
                   DESC

  s.homepage     = "https://github.com/Wmileo/EasyModel"
  s.license      = "MIT"
  s.author             = { "leo" => "work.mileo@gmail.com" }

  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/Wmileo/EasyModel.git", :tag => s.version.to_s }
  s.source_files  = "EasyModel/EasyModel/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
