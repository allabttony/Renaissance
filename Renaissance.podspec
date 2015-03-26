Pod::Spec.new do |s|
  s.name = 'Renaissance'
  s.version = '1.0.0'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = 'Renaissance is a custom camera that can capture photo'
  s.homepage = 'https://github.com/allabttony/Renaissance'
  s.author = { 'Tony Chan' => 'allabttony@gmail.com' }
  s.source = { :git => 'https://github.com/allabttony/Renaissance.git', :tag => s.version }
  s.platform = :ios, '7.0'
  s.requires_arc = true

	s.subspec "Core" do |ss|
    ss.source_files  = 'RenaissanceDemo/RenaissanceDemo/Renaissance/*.{h,m}', 'RenaissanceDemo/RenaissanceDemo/Renaissance/Category/*.{h,m}'
		ss.resources = 'RenaissanceDemo/RenaissanceDemo/Renaissance/Resources/*.png'
    ss.dependency "PBJVision"
  end

end
