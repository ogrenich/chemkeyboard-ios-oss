# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Pods for ChemKeyboard
def common
    
    pod 'Reveal-SDK', :configurations => ['Debug']
    
    pod 'Fabric', '1.7.0'
    pod 'Crashlytics', '3.9.0'
    
    pod 'RxCocoa', '4.0.0'
    pod 'RxRealm', '0.7.3'
    
end

target 'ChemKeyboard' do
    
  common
  
end

target 'Keyboard' do

  common

end

# Acknowledgements
plugin 'cocoapods-acknowledgements', :exclude => ['Reveal-SDK']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name.include?("Pods-ChemKeyboard")
            require 'fileutils'

            FileUtils.cp_r('Pods/Target Support Files/Pods-ChemKeyboard/Pods-ChemKeyboard-acknowledgements.plist',
                           'ChemKeyboard/Settings/Settings.bundle/Acknowledgements.plist',
                           :remove_destination => true)
        end
    end
end
