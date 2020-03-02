//
//  NewJoltyViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage
import Alamofire
import SnapKit
import RealmSwift
import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import Firebase
import GeoFire
import BubbleTransition
import Lottie
import FirebaseDatabase
import FirebaseStorage
import SpriteKit
import ZAlertView
import MaterialShowcase

let downloadedBoxesNotificationKey = "com.jolty.downloadedBoxes"

class NewJoltyViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView! 
    
    private var geoFireRef: DatabaseReference?
    private var geoFire: GeoFire?
    private var myQuery: GFQuery?
    
    private var batteryStatusView: BatteryStatusView!
    private var sendHelpView: SendHelpView!
    private var guestInfoView: GuestInfoView!
    private var finishJobView: FinishJobView!
    private var rateGuestView: RateGuestView!
    
    private var circleRadius: MKCircle!
    
    private let pageControl = UIPageControl()
    private let transition = BubbleTransition()
    
    private let interactiveTransition = BubbleInteractiveTransition()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private var guestAnnotationPin = MKPointAnnotation()
    private var centerLocBarButtonItem: UIBarButtonItem!
    
    private var newJoltyId = ""
    
    private var boxes = [Box]()
    
    private var dialog: ZAlertView!
    
    private var currentGuestLocation: CLLocation? {
        didSet {
            
            let locations = [
                currentLocation,
                currentGuestLocation
            ]
            
            addPolyLineToMap(locations: locations)
        }
    }
    
    private var searchingAnimationView: SearchingAnimationView! {
        didSet {
            if searchingAnimationView == nil {
                showTabBar()
                showMainMenuButton()
            }  
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.isFirstLaunch() {
            configureShowcaseGuide()
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //configureViewWithUserData()
        
        self.navigationItem.title = "Jolty".localized()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppInitSetConfig.appFontColor(),
                                                                        NSAttributedStringKey.font: UIFont.OpenSansRegular(fontSize: 22)]
        
        
        view.backgroundColor = AppInitSetConfig.appFontColor()
        
        setNavBarItems()
        showTabBar()
        configureLocationAndMapSettings()
        checkIfUserNeedsLowPowerMode()
        //centerOnUserLocation(sender: nil)
        updateCurrentBatteryInFirebase()
        setCurrentState()
        getJoltyBoxesFromApi()
        
        mapView.refreshUserLocationAnnotation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func appMovedToForeground() {
       removeSearchingAnimationView()
    }
    
    func configureShowcaseGuide() {
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: sendHelpView.sendHelpBtn) // always required to set targetView
        
        // Background
        showcase.backgroundPromptColor = AppInitSetConfig.appBackColor()
        showcase.backgroundPromptColorAlpha = 0.96
        showcase.backgroundViewType = .circle // default is .circle
        
        // Text
        showcase.primaryTextColor = AppInitSetConfig.appFontColor()
        showcase.secondaryTextColor = AppInitSetConfig.appFontColor()
        showcase.primaryTextFont = UIFont.OpenSansRegular(fontSize: 20)
        showcase.secondaryTextFont = UIFont.OpenSansRegular(fontSize: 15)
        
        showcase.primaryText = "Tap to find a charger sharer".localized()
        showcase.secondaryText = ""
        
        showcase.show(completion: {
            // You can save showcase state here
            // Later you can check and do not show it again
        })
        
    }
    
    @objc func getJoltyBoxesFromApi() {
        
        if boxes.isEmpty {
        if let lastKnownLocation = LocationManager.sharedManager.lastLocation {
            LocationManager.getCityName(coords: lastKnownLocation, completion: { (city) in
                APIManager.getJoltyBoxes(fromCity: city) { (boxes, error) in
                    
                    if error == nil {
                        self.boxes = boxes!
                        NotificationCenter.default.post(name: Notification.Name(rawValue: downloadedBoxesNotificationKey), object: boxes)
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        
                        for (_, box) in (boxes?.enumerated())! {
                            let annotation = box.annotation
                            if annotation != nil {
                                self.mapView.addAnnotation(annotation!)
                            }
                        }
                        
                        SVProgressHUD.dismiss()
                        
                    } else {
                        SVProgressHUD.showError(withStatus: "There was a problem downloading the Jolty Boxes".localized())
                        
                    }
                }
            })
            }
        }
    }
    
    func updateCurrentBatteryInFirebase() {
        if let userId = Auth.auth().currentUser?.uid {
            Database.database().reference().child("Users").child(userId).child("user_details").updateChildValues(["current_batteryLvl": "\(CurrentBattery.batteryLevelPercentage())"])
        }
    }
    
    func setCurrentState() {
        
        if UserDefaults.standard.dictionary(forKey: "guestDetails") != nil {
            removeOverlayViews()
            
            addGuestInfoView()
            getGuestLocation()
            setGuestLocationObserver()
            removeMapOverlays()
            
        } else {
            
            addCurrentBatteryStateView()
            addSendHelpView()

        }
    }
    
    func addRadiusCircle(location: CLLocation) {
        circleRadius = nil
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        let selectedRange = UserModelShared.currentUserData(attribute: "selected_range").toDouble()
        
        circleRadius = MKCircle(center: location.coordinate, radius: selectedRange as! CLLocationDistance)
        self.mapView.add(circleRadius)
        
        mapView.reloadInputViews()
    }
    
    func removeMapOverlays() {
        self.mapView.overlays.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.remove($0)
                circleRadius = nil
            }
        }
    }
    
    func setNavBarItems() {
        centerLocBarButtonItem = UIBarButtonItem(image: UIImage.myLocation(), style: .plain, target: self, action: #selector(centerOnUserLocation))
        
        navigationItem.setRightBarButton(centerLocBarButtonItem, animated: false)
    }
    
    @objc fileprivate func centerOnUserLocation(sender: AnyObject?) {
        if let lastKnownLocation = LocationManager.sharedManager.lastLocation {
            
            addRadiusCircle(location: lastKnownLocation)
            mapView.centerInCoordinates(lastKnownLocation.coordinate, animated: false)
        } else {
            present(AlertControllerHelper.presentRequestLocationAlert(), animated: true, completion: nil)
        }
    }
    
    func zoomMapViewToUserLocation() {
        //Zoom to user location
        let viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!), 200, 200)
        mapView.setRegion(viewRegion, animated: true)
        
    }
    
    func centerMapOnCurrentUserLocation() {
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    func checkIfUserNeedsLowPowerMode() {
        switch User.BatteryState {
        case .perfect:
            print("user battery is perfect")
        case .veryGood:
            print("user battery is very good")
        case .ok:
            print("user battery is ok")
        case .alive:
            print("user battery is alive")
            _ = presentLowPowerModeAlert
        case .dying:
            print("user battery is dying")
            _ = presentLowPowerModeAlert
        case .none:
            print("user has none")
        }
    }
    
    private lazy var presentLowPowerModeAlert: Void = {
        if CurrentBattery.batteryLowPowerModeEnabled() == false {
            present(AlertControllerHelper.presentLowPowerModeAlert(), animated: true, completion: nil)
        }
    }()
    
    func configureLocationAndMapSettings() {
        // For use in foreground
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    func getGuestLocation() {
        if let guestId = UserDefaults.standard.string(forKey: "guestId") {
            geoFireRef = Database.database().reference().child("Geolocs")
            geoFire = GeoFire(firebaseRef: geoFireRef!)
            geoFire?.getLocationForKey(guestId, withCallback: { (location, error) in
                self.currentGuestLocation = location
                self.setGuestLocationObserver()
            })
        }
    }
    
    func setGuestLocationObserver() {
        if let guestId = UserDefaults.standard.string(forKey: "guestId") {
            geoFireRef = Database.database().reference().child("Geolocs").child("l")
            geoFireRef?.child(guestId).observe(.childChanged) { (snapshot) in
                let loc = snapshot.value as! [Double]
                self.currentGuestLocation = CLLocation(latitude: loc.first!, longitude: loc.last!)
            }
        }
    }

    
    func createNewJolty(lastMessage: String) {
        
        let newJolty = [
            "saviourUser": "",
            "helpedUser": Auth.auth().currentUser!.uid,
            "start" : DateManager.getCurrentDate()
            ] as [String : Any]
        
            newJoltyId = generateJoltyId()
        Database.database().reference().child("Jolty").child(newJoltyId).setValue(newJolty)
        Database.database().reference().child("Jolty").child(newJoltyId).observe(.childChanged) { (snapshot) in
            print(snapshot)
            let guestId = String(describing: snapshot.value!)
            
            UserModel.guestInfo(forGuestID: guestId, completion: { (userModel) in
                DispatchQueue.main.async(execute: {
                    
                    self.removeOverlayViews()
                    self.addGuestInfoView()
                    self.getGuestLocation()
                })
            })
        }
        
        findNearByUsersAndSendCloudMessage(JoltyId: newJoltyId, helpUserId: Auth.auth().currentUser!.uid, lastMessage: lastMessage)
        
        //        let timer = Timer(timeInterval: 0.4, repeats: true) { _ in print("Done!") }
        
    }
    
    func removeCurrentJolty() {
        Database.database().reference().child("Jolty").child(newJoltyId).removeValue()
    }
    
    func generateJoltyId() -> String {
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*10000)
        return String(timeStamp)
    }
    
}

//MARK: Add Overlay subviews
extension NewJoltyViewController {
    
    func addRateGuestView() {
        
        if rateGuestView == nil {
            
            if rateGuestView == nil {
                rateGuestView = (RateGuestView.initFromNib() as? RateGuestView)
            }
            
            if rateGuestView!.superview == nil {
                mapView.addSubview(rateGuestView!)
                rateGuestView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.top.equalTo(mapView)
                    make.height.equalTo(GuestInfoView.preferredHeight)
                })
            }
            
            rateGuestView.delegate = self
        }
    }
    
    func addFinishJobView() {
        
        if finishJobView == nil {
            
            if finishJobView == nil {
                finishJobView = (FinishJobView.initFromNib() as? FinishJobView)
            }
            
            if finishJobView!.superview == nil {
                mapView.addSubview(finishJobView!)
                finishJobView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.equalTo(mapView)
                    make.height.equalTo(FinishJobView.preferredHeight)
                })
            }
            
            finishJobView.delegate = self
            
        }
    }
    
    func addGuestInfoView() {
        
        if guestInfoView == nil {
            
            if guestInfoView == nil {
                guestInfoView = (GuestInfoView.initFromNib() as? GuestInfoView)
            }
            
            if guestInfoView!.superview == nil {
                mapView.addSubview(guestInfoView!)
                guestInfoView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.top.equalTo(mapView)
                    make.height.equalTo(GuestInfoView.preferredHeight)
                })
                
            }
            
            guestInfoView.delegate = self
            
        }
    }
    
    func addSearchingAnimationView() {
        
        if searchingAnimationView == nil {
            
            if searchingAnimationView == nil {
                searchingAnimationView = (SearchingAnimationView.initFromNib() as? SearchingAnimationView)
            }
            
            if searchingAnimationView!.superview == nil {
                mapView.addSubview(searchingAnimationView!)
                searchingAnimationView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.top.equalTo(mapView)
                    make.height.equalTo(SearchingAnimationView.preferredHeight)
                })
            }
            
            searchingAnimationView.delegate = self
            
            searchingAnimationView!.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.searchingAnimationView!.alpha = 1
            })
        }
    }
    
    func addSendHelpView() {
        
        if sendHelpView == nil {
            
            if sendHelpView == nil {
                sendHelpView = (SendHelpView.initFromNib() as? SendHelpView)
            }
            
            if sendHelpView!.superview == nil {
                mapView.addSubview(sendHelpView!)
                sendHelpView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.equalTo(mapView)
                    make.height.equalTo(SendHelpView.preferredHeight)
                })
            }
            
            sendHelpView.delegate = self
        }
        
    }
    
    func addCurrentBatteryStateView() {
        
        if batteryStatusView == nil {
            
            if batteryStatusView == nil {
                batteryStatusView = (BatteryStatusView.initFromNib() as? BatteryStatusView)
            }
            
            if batteryStatusView!.superview == nil {
                mapView.addSubview(batteryStatusView!)
                batteryStatusView!.snp.makeConstraints({ (make) in
                    make.left.top.right.equalTo(mapView)
                    make.height.equalTo(BatteryStatusView.preferredHeight)
                })
            }
        }
    }
}


//MARK: Remove Overlay subviews
extension NewJoltyViewController {
    
    fileprivate func removeOverlayViews() {
        batteryStatusView?.removeFromSuperview()
        batteryStatusView = nil
        sendHelpView?.removeFromSuperview()
        sendHelpView = nil
        searchingAnimationView?.removeFromSuperview()
        searchingAnimationView = nil
        guestInfoView?.removeFromSuperview()
        guestInfoView = nil
        finishJobView?.removeFromSuperview()
        finishJobView = nil
        rateGuestView?.removeFromSuperview()
        rateGuestView = nil
    }
    
    fileprivate func removeGuestInfoView() {
        guestInfoView?.removeFromSuperview()
        guestInfoView = nil
    }
        
    fileprivate func removeBatteryStatusView() {
        batteryStatusView?.removeFromSuperview()
        batteryStatusView = nil
    }
    
    fileprivate func removeSendHelpView() {
        sendHelpView?.removeFromSuperview()
        sendHelpView = nil
    }
    
    fileprivate func removeSearchingAnimationView() {
        searchingAnimationView?.removeFromSuperview()
        searchingAnimationView = nil
    }
    
    fileprivate func removeFinishJobView() {
        finishJobView?.removeFromSuperview()
        finishJobView = nil
    }
    
    fileprivate func removeRateGuestView() {
        rateGuestView?.removeFromSuperview()
        rateGuestView = nil
    }
    
    fileprivate func hideTabBar() {
        self.parent?.tabBarController?.setTabBarVisible(visible: false, duration: 0, animated: false)
    }
    
    fileprivate func showTabBar() {
        self.parent?.tabBarController?.setTabBarVisible(visible: true, duration: 0, animated: false)
    }
    
    fileprivate func hideMainMenuButton() {
        TabBarController.MainButton.menuButton.isHidden = true
    }
    
    fileprivate func showMainMenuButton() {
        TabBarController.MainButton.menuButton.isHidden = false
    }
    
    fileprivate func showOrHideNavBarLocationBtn() {
        if mapView.isUserLocationVisible {
            UIView.animate(withDuration: 0.3) {
                if let button = self.navigationItem.rightBarButtonItem {
                    button.isEnabled = false
                    button.tintColor = UIColor.clear
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                if let button = self.navigationItem.rightBarButtonItem {
                    button.isEnabled = true
                    button.tintColor = AppInitSetConfig.appFontColor()
                }
            }
        }
    }
    
    fileprivate func hideJoltyrsFoundLbl() {
        searchingAnimationView.JoltyrsFoundLbl.isHidden = true
        searchingAnimationView.JoltyrsFoundLbl.alpha = 1
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.searchingAnimationView.JoltyrsFoundLbl.alpha = 0
        })
    }
    
    fileprivate func ShowJoltyrsFoundLbl(quantity: Int) {
        searchingAnimationView.JoltyrsFoundLbl.text = "\(quantity) " + "Joltyrs found".localized()
        searchingAnimationView.JoltyrsFoundLbl.isHidden = false
        searchingAnimationView.JoltyrsFoundLbl.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.searchingAnimationView.JoltyrsFoundLbl.alpha = 1
        })
    }
}


extension NewJoltyViewController {
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if view.isKind(of: BoxAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
        
        // Get Box Annotation Type from Select
        if let boxAnnotationView = view as? BoxAnnotationView,
            let boxAnnotation = boxAnnotationView.annotation as? BoxAnnotation {
            boxAnnotationView.image = UIImage.boxPin()
        }
    }

    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        
        // Get Box Annotation Type from Select
        if let boxAnnotationView = view as? BoxAnnotationView,
            let boxAnnotation = boxAnnotationView.annotation as? BoxAnnotation {
            
            let box = boxAnnotation.box
            
            //Set inverted color image selected marker
            boxAnnotationView.image = UIImage.boxPinSelected()
            
            let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
            let calloutView = views![0] as! CustomCalloutView
            calloutView.lblTitle.text = box?.name
            // 3
            calloutView.center = CGPoint(view.bounds.size.width / 2, -calloutView.bounds.size.height*0.52)
            calloutView.layer.cornerRadius = 4.0
            calloutView.isUserInteractionEnabled = true
            calloutView.alpha = 0
            //            let tap = UITapGestureRecognizer(target: self, action: #selector(NewJoltyViewController.handleCalloutTap(_:)))
            //            calloutView.addGestureRecognizer(tap)
            self.view.bringSubview(toFront: calloutView)
            
            view.addSubview(calloutView)
            
            UIView.animate(withDuration: 0.25) { () -> Void in
                calloutView.alpha = 1.0
            }
        }
    }
    
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = AppInitSetConfig.appBackColor().withAlphaComponent(0.8)
            pr.lineWidth = 5
            return pr
        }
        
        return nil
    }
    
    func addPolyLineToMap(locations: [CLLocation?])
    {
        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.add(polyline)
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        // Hide or show Loc Btn
        //showOrHideNavBarLocationBtn()
        
        if currentLocation == nil {
            
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                mapView.setRegion(viewRegion, animated: false)
                
                if let user = Auth.auth().currentUser {
                    geoFireRef = Database.database().reference().child("Geolocs")
                    geoFire = GeoFire(firebaseRef: geoFireRef!)
                    geoFire?.setLocation(locations.last!, forKey: user.uid, withCompletionBlock: { (error) in
                    })
                }
                
                let usrDefaults:UserDefaults = UserDefaults.standard
                
                usrDefaults.set("\(userLocation.coordinate.latitude)", forKey: "current_latitude")
                usrDefaults.set("\(userLocation.coordinate.longitude)", forKey: "current_longitude")
                usrDefaults.synchronize()
                
                getJoltyBoxesFromApi()
            }
        }
    }
    
    // MARK - rendererForOverlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = AppInitSetConfig.appBackColor()
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else  if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = AppInitSetConfig.appBackColor().withAlphaComponent(0.8)
            pr.lineWidth = 5
            return pr
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            let userAnnotationView = UserAnnotationView.reusableAnnotationViewForMap(mapView: mapView, forAnnotation: annotation)
            
            if Auth.auth().currentUser != nil {
                userAnnotationView.canShowCallout = true
                
                UIImage.currentUserProfilePicImage(completionBlock: { (image) in
                    
                    let texture = SKTexture(image: image)
                    let mySprite = SKSpriteNode(texture: texture)
                    let finalImage = UIImage(cgImage: (mySprite.texture?.cgImage())!)
                    
                    userAnnotationView.image = finalImage
                })
                
            } else {
                userAnnotationView.image = UIImage.localPinColored()
            }
            
            return userAnnotationView
        }
        
        guard !annotation.isKind(of: MKPointAnnotation.self) else {
            let userAnnotationView = UserAnnotationView.reusableAnnotationViewForMap(mapView: mapView, forAnnotation: annotation)
            
            if Auth.auth().currentUser != nil {
                userAnnotationView.canShowCallout = true
                UIImage.currentGuestProfilePicImage(completionBlock: { (image) in
                    userAnnotationView.image = image
                })
            } else {
                userAnnotationView.image = UIImage.localPinColored()
            }
            
            return userAnnotationView
        }
        
        if let boxAnnotation = annotation as? BoxAnnotation {
            let boxAnnotationView = BoxAnnotationView.reusableAnnotationViewForMap(mapView: mapView, forAnnotation: boxAnnotation)
            return boxAnnotationView
        }
        
        return nil
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension NewJoltyViewController: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginVC = segue.destination as! LoginViewController
        loginVC.transitioningDelegate = self
        loginVC.modalPresentationStyle = .custom
        interactiveTransition.attach(to: loginVC)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = sendHelpView.sendHelpBtn.center
        transition.bubbleColor = sendHelpView.sendHelpBtn.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = sendHelpView.sendHelpBtn.center
        transition.bubbleColor = sendHelpView.sendHelpBtn.backgroundColor!
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.finish()
        interactiveTransition.wantsInteractiveStart = false
        return interactiveTransition
    }
    
}

// MARK: View Elements Delegate Methods

extension NewJoltyViewController: SendHelpViewDelegate, SearchingAnimationViewDelegate, GuestInfoViewDelegate, FinishJobViewDelegate, RateGuestDelegate {
    
    func sendLastMessage() {
        if let lastTxt = dialog.getTextFieldWithIdentifier("lastMessage")?.text {
                        
            hideMainMenuButton()
            hideTabBar()
            
            centerMapOnCurrentUserLocation()
            zoomMapViewToUserLocation()
            removeBatteryStatusView()
            addSearchingAnimationView()
            createNewJolty(lastMessage: lastTxt)
            
        }
    }
    
    func guestWasRated() {
        
        SVProgressHUD.dismiss()
        print("guest was rated!, go back to origin")
        
        UserDefaults.standard.removeObject(forKey: "guestDetails")
        UserDefaults.standard.removeObject(forKey: "guestId")
        
        mapView.removeAnnotation(guestAnnotationPin)
        mapView.view(for: guestAnnotationPin)
        
        removeOverlayViews()
        removeMapOverlays()
        setCurrentState()
    }
    
    func jobFinished() {
        
        PopUpHelper.didFoundGuestPopUp(leftButtonBlock: { (alert) in
            
            self.removeFinishJobView()
            self.addRateGuestView()
            
            UserModel.isChargerSharer(newState: "true")
            
            alert.dismissAlertView()
        }) { (alert) in
            alert.dismissAlertView()
        }.show()
    }
    
    // Begin internet
    func jobStarted() {
        addCurrentBatteryStateView()
        addFinishJobView()
        
        guestAnnotationPin.coordinate = CLLocationCoordinate2D(latitude: currentGuestLocation!.coordinate.latitude, longitude: currentGuestLocation!.coordinate.longitude)
        
        mapView.addAnnotation(guestAnnotationPin)
        mapView.view(for: guestAnnotationPin)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func cancelSearchingCable() {
        
        removeOverlayViews()
        removeCurrentJolty()
        
        addCurrentBatteryStateView()
        addSendHelpView()
        showTabBar()
    }
    
    func sendHelpTouched() {
        
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "toLoginVc", sender: nil)
        } else {
            
            if checkAvailableZone() == true {
                
                dialog = ZAlertView()
                dialog.message = "Describe why someone should lend you a charger".localized()
                
                dialog.addTextField("lastMessage", placeHolder: "Forgot my charger at home! I invite you a coffee".localized())
                
                dialog.closeHandler =  { (alert) -> () in
                    self.sendLastMessage()
                    alert.dismissAlertView()
                }
                
                dialog.closeTitle = "Bring help".localized()
                
                //dismissView method
                
                dialog.height = 550
                dialog.width = 350
                                        
                dialog.show()
                
                //addLastMessagePopUpView()
            } else {
                
                ZAlertView(title: "We haven't arrived here yet".localized(), message: "Asking for help is not currently available in your area".localized(), closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()
            
            }
        }
    }
}

//Available Zones
extension NewJoltyViewController {
    
    func checkAvailableZone() -> Bool {
        
        //map.geojson Contains all supported areas
        //Current available Zone is Barcelona
        
        if let path = Bundle.main.path(forResource: "map", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                guard let points = try? JSONDecoder().decode(Points.self, from: data) else {
                    print("Error: Couldn't decode data into Blog")
                    return false
                }
                
                var allCoordinates = [CLLocationCoordinate2D]()
                
                for point in points.features {
                    let coord = point.geometry.getCoordinates()
                    allCoordinates.append(contentsOf: coord)
                }
                
                let myCoordinates = currentLocation!.coordinate
                
                let pol = Poligono(coordinates: allCoordinates, count: allCoordinates.count)
                let point = MKMapPointForCoordinate(myCoordinates)
                let mapRect = MKMapRectMake(point.x, point.y, 0, 0);
                
                if pol.intersects(mapRect) {//Touch in polygon
                    print("OK")
                    return true
                } else {
                    return false
                }
                
            } catch {
                // handle error
            }
        }
        
        return true
        
    }
    
    func validateCurrentUserCredits(credits: Int) -> Bool {
        if credits > 0 {
            return true
        } else {
            return false
        }
    }
    
    func validateCurrentBatteryLvl() -> Bool {
        if CurrentBattery.batteryLevelPercentage() < 30 {
            return true
        } else {
            return false
        }
    }
    
}


//Search for user in GeoZone
extension NewJoltyViewController {
    
    func findNearByUsersAndSendCloudMessage(JoltyId: String, helpUserId: String, lastMessage: String) {
        
        // Do any additional setup after loading the view.
        
        geoFireRef = Database.database().reference().child("Geolocs")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
        let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
        
        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        
        let selectedRange = UserModelShared.currentUserData(attribute: "selected_range")
        let selectedRangeDouble = selectedRange!.toDouble()
        //Set to KM
        let range = selectedRangeDouble! * 0.001
        
        myQuery = geoFire?.query(at: location, withRadius: range)
        
        myQuery?.observe(.keyEntered, with: { (key, location) in
            
            // print("KEY:\(String(describing: key)) and location:\(String(describing: location))")
            
            if key != Auth.auth().currentUser?.uid
            {
                let ref = Database.database().reference().child("Users").child(key)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let data = snapshot.value as! [String: Any]
                    let credentials = data["user_details"] as! [String: String]
                    let shareLightning = credentials["share_lightning"]! as String
                    let currentFcmToken = credentials["currentFcmToken"]!
                    
                    let isSharer = Bool(shareLightning)
                    
                    if isSharer! {
                        
                        let name = UserModelShared.currentUserData(attribute: "name")
                        let batteryPerc = CurrentBattery.batteryLevelPercentage()
                        
                        let title = "\(String(describing: name!)) " + "needs a charger:".localized()
                        
                        let body = "\"\(lastMessage)\"\n" + "has".localized() + " \(batteryPerc) % \n" + "Be the first to help!".localized()
                        
                        FirebasePushNotificationsManager.sendCloudMessage(title: title, body: body, toToken: currentFcmToken, JoltyId: JoltyId, helpUserId: helpUserId, name: name!)
                    }
                })
            }
            else
            {
                
            }
        })
    }
}

class Poligono: MKPolygon {
    var someVariable : String?
}

