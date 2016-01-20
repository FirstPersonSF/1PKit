Pod::Spec.new do |spec|
  spec.name = "FPKit"
  spec.version = "1.0.0"
  spec.summary = "First Person iOS Kit"
  spec.homepage = "https://github.com/FirstPersonSF/FPKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Sruti Harikumar" => 'sruti@firstperson.is',
                    "Fernando Toledo" => 'fernando@firstperson.is'}
  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/FirstPersonSF/FPKit.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "FPKit/FPKit/**/*.{h,swift}"
end
