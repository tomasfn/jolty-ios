//
//  AppImages.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Kingfisher
import SpriteKit

typealias GetImageCompletionBlock = (UIImage) -> Void

//MARK: App Images
extension UIImage {
    
    //MARK: User Profile Picture
    class func currentUserProfilePicImage(completionBlock: @escaping GetImageCompletionBlock) {
        
        let userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")

        let profilePicUrl = URL(string: (userInfo!["profilepic_url"] as? String)!)
        
        ImageDownloader.default.downloadImage(with: profilePicUrl!, retrieveImageTask: nil, options: [], progressBlock: nil) { (img, error, url, data) in
            print("Downloaded Image: \(String(describing: url))")
            
            if let image = img {
                let roundImg = image.circleMasked
                completionBlock(roundImg!.resizeImage(targetSize: CGSize(width:80, height:80)))
            } else {
                let placeHolder = UIImage.profilePlaceholder().circleMasked
                completionBlock(placeHolder!.resizeImage(targetSize: CGSize(width:80, height:80)))
            }
  
            //cache image
            
            if let image =  img, let url = url {
                ImageCache.default.store(image, forKey: url.absoluteString)
            }
        }
    }
    
    //MARK: Guest Profile Picture
    class func currentGuestProfilePicImage(completionBlock: @escaping GetImageCompletionBlock) {
        
        let userInfo = UserDefaults.standard.dictionary(forKey: "guestDetails")
        
        let profilePicUrl = URL(string: (userInfo!["profilepic_url"] as? String)!)
        
        ImageDownloader.default.downloadImage(with: profilePicUrl!, retrieveImageTask: nil, options: [], progressBlock: nil) { (img, error, url, data) in
            print("Downloaded Image: \(String(describing: url))")
            
            if let image = img {
                let roundImg = image.circleMasked
                completionBlock(roundImg!.resizeImage(targetSize: CGSize(width:80, height:80)))
            } else {
                let placeHolder = UIImage.profilePlaceholder().circleMasked
                completionBlock(placeHolder!.resizeImage(targetSize: CGSize(width:80, height:80)))
            }
            
            if let image =  img, let url = url {
                ImageCache.default.store(image, forKey: url.absoluteString)
            }
        }
    }
    
    //MARK: For User Profile View
    class func logoutUser() -> UIImage! {
        return UIImage(named: "logout")
    }
    
    //MARK: For Login
    class func facebook() -> UIImage! {
        return UIImage(named: "facebook")
    }
    
    class func twitter() -> UIImage! {
        return UIImage(named: "twitter")
    }
    
    class func profilePlaceholder() -> UIImage! {
        return UIImage(named: "default-profile")
    }
    
    //MARK: Misc
    class func lightningCable() -> UIImage! {
        return UIImage(named: "findCharger")
    }
    
    class func magSafe() -> UIImage! {
        return UIImage(named: "bg")
    }
    
    class func JoltyIcon() -> UIImage! {
        return UIImage(named: "whiteLightning")?.maskWithColor(color: AppInitSetConfig.appFontColor())
    }
    
    class func leftArrow() -> UIImage! {
        return UIImage(named: "leftArrow")?.maskWithColor(color: AppInitSetConfig.appBackColor())
    }
    
    class func rightArrow() -> UIImage! {
        return UIImage(named: "rightArrow")
    }
    
    static var commonPlaceHolder: UIImage! {
        return UIImage(named: "beneficios-vacio")
    }
    
    
    //MARK: MapView
    class func localPinColored() -> UIImage! {
        let resizedPin = UIImage(named: "mapMarker")?.resizeImage(targetSize: CGSize(width:60, height:60))
        return resizedPin!.maskWithColor(color: AppInitSetConfig.appBackColor())
    }
    
    class func boxPin() -> UIImage! {
        let pin = UIImage(named: "boxMarker")
        return pin
    }
    
    class func boxPinSelected() -> UIImage! {
        let pin = UIImage(named: "boxMarkerInverted")
        return pin
    }
    
    //MARK: Rate scale for Users
    class func bad() -> UIImage! {
        return UIImage(named: "bad")!.maskWithColor(color: AppInitSetConfig.appFontColor())
    }
    
    class func normal() -> UIImage! {
        return UIImage(named: "normal")!.maskWithColor(color: AppInitSetConfig.appFontColor())
    }
    
    class func good() -> UIImage! {
        return UIImage(named: "good")!.maskWithColor(color: AppInitSetConfig.appFontColor())
    }
    
    class func veryGood() -> UIImage! {
        return UIImage(named: "very-good")!.maskWithColor(color: AppInitSetConfig.appFontColor())
    }
    
    //MARK: General
    class func search() -> UIImage! {
        return UIImage(named: "ic-search")
    }
    
    class func menu() -> UIImage! {
        return UIImage(named: "menu")
    }
    
    class func myLocation() -> UIImage! {
        return UIImage(named: "myLocation")
    }
    
    class func menuBlack() -> UIImage! {
        return UIImage(named: "ic-menu-black")
    }
    
    class func logut() -> UIImage! {
        return UIImage(named: "ic-logout")
    }
    
    class func favOn() -> UIImage! {
        return UIImage(named: "ic-fav-on")
    }
    
    class func favOff() -> UIImage! {
        return UIImage(named: "ic-fav-off")
    }
    
    class func edit() -> UIImage! {
        return UIImage(named: "ic-edit")
    }
    
    class func icDelivery() -> UIImage! {
        return UIImage(named: "ic-delivery")
    }
    
    class func icClose() -> UIImage! {
        return UIImage(named: "ic-close")
    }
    
    class func icBack() -> UIImage! {
        return UIImage(named: "ic-back")
    }
    
    
    class func delete() -> UIImage! {
        return UIImage(named: "ic-delete")
    }
    
    
    //MARK: Profile
    class func profileBirthday() -> UIImage! {
        return UIImage(named: "ic-birthday")
    }
    
    class func profilePass() -> UIImage! {
        return UIImage(named: "ic-pass")
    }
    
    class func profileUser() -> UIImage! {
        return UIImage(named: "ic-user")
    }
    
    class func profileMail() -> UIImage! {
        return UIImage(named: "ic-mail")
    }
    
    class func profileGender() -> UIImage! {
        return UIImage(named: "ic-gender")
    }
    
    //MARK: Splash
    class func splashImage() -> UIImage! {
        return UIImage(named: "splash")
    }
}

class CircledImage {
    class func maskRoundedImage(image: UIImage) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = imageView.height / 2
        layer.borderWidth = 4.0
        layer.borderColor = AppInitSetConfig.appFontColor().cgColor
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
}

