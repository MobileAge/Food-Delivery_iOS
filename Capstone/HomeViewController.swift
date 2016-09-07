//
//  HomeViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 9/30/15.
//  Copyright © 2015 MobileAge Team.  All rights reserved.
//

import UIKit
import MMDrawerController
import GoogleMaps
import Parse

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var placeOptionsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typePicker: UIPickerView!
    
    let pickerData = ["Scroll to Search by Category", "Food/Fast Food", "Restaurant", "Grocery Store", "Convenience Store", "Liquor Store"]
    let typeString = ["", "food", "restaurant", "grocery_or_supermarket", "convenience_store", "liquor_store"]
    
    var selectedType:String = ""
    var searchString:String = ""
    
    var placeName:String = ""
    var placeAddress: String = ""
    
    var searchActive : Bool = false
    var showSearchFields = true
    
    let locationManager = CLLocationManager()
    var hasLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        mapView.delegate = self
        typePicker.dataSource = self
        typePicker.delegate = self
        searchBar.delegate = self
        
        hasLocation = false
        if(PFUser.currentUser()!["FavoritePlaces"] == nil){
            PFUser.currentUser()!["FavoritePlaces"] = []
            PFUser.currentUser()!.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    print(errorString)
                }
            }
        }
        
        self.view.sendSubviewToBack(placeOptionsView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func drawerMenuClicked(sender: UIBarButtonItem) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            //loadPlaces(location.coordinate)
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedType = typeString[row]
        if(row != 0){
            self.fetchNearbyPlaces(mapView.camera.target)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.searchString = self.searchBar.text!
        return pickerData.count
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchString = self.searchBar.text!
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchString = ""
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchString = self.searchBar.text!
        self.fetchNearbyPlaces(mapView.camera.target)
        searchActive = false;
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        let dataFetcher = GoogleRequest()
        self.searchString = self.searchBar.text!
        mapView.clear()
        if(self.searchString == "" && self.selectedType == ""){
            let uiAlert = UIAlertController(title: "Missing Search Criteria", message: "Please select a catagory to search, or search for places by name.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                
            }))
        }else{
            let searchDist:Float = PFUser.currentUser()!.getSearchDistance()
            let metersSearchDist: Int = Int(searchDist*1609.34)
            print("MetersDist: \(metersSearchDist)")
            dataFetcher.loadPlaces(coordinate, searchDist: metersSearchDist, searchStr: self.cleanSearchString(self.searchString), typeStr: self.selectedType) { places in
                for place: Place in places {
                    let marker = PlaceMarker(place: place)
                    print("ADDRESS: \(marker.place.address)")
                    marker.map = self.mapView
                    
                }
            }
        }
    }
    func cleanSearchString(text: String) -> String {
        let charSet = NSCharacterSet(charactersInString: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").invertedSet
        
        let cleanedString = text.componentsSeparatedByCharactersInSet(charSet).joinWithSeparator("").stringByReplacingOccurrencesOfString(" ", withString: "_")
        print(cleanedString)
        
        return cleanedString

    }
    
    @IBAction func refreshSearchButtonAction(sender: UIBarButtonItem) {
        mapView.clear()
        self.view.sendSubviewToBack(self.placeOptionsView)
        self.fetchNearbyPlaces(mapView.camera.target)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "PlaceOrderFromHereSegue") {
            let custOrderViewController = segue.destinationViewController as! CustomerOrderViewController
            custOrderViewController.pickUpNameText = self.placeName
            custOrderViewController.pickUpAddressText = self.placeAddress
        }
    }
    
    @IBAction func addToFavoritesButtonAction(sender: UIButton) {
        var userFavorites:[String] = PFUser.currentUser()!["FavoritePlaces"] as! [String]
        let newFavorite:String = "\(self.placeName)|||\(self.placeAddress)"
        if(!userFavorites.contains(newFavorite)){
            userFavorites.append(newFavorite)
            PFUser.currentUser()!["FavoritePlaces"] = userFavorites
            PFUser.currentUser()!.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    print(errorString)
                }
            }
            let uiAlert = UIAlertController(title: "Favorites", message: "\(self.placeName) was added to your Favorite Places list.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            }))
        }else{
            let uiAlert = UIAlertController(title: "Favorites", message: "\(self.placeName) is already in your Favorite Places list.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            }))
        }
    }

}

extension HomeViewController: GMSMapViewDelegate {
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapView.selectedMarker = nil
        return false
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.view.sendSubviewToBack(placeOptionsView)
    }

    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! PlaceMarker
        
        if let infoView = NSBundle.mainBundle().loadNibNamed("PlaceInfoView", owner: nil, options: nil).first as? PlaceInfoView {
            
            infoView.nameLabel.text = placeMarker.place.name
            infoView.addressLabel.text = placeMarker.place.address
            
            if(placeMarker.place.open){
                infoView.openLabel.text = "Open Now"
                infoView.openLabel.textColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
            }else{
                infoView.openLabel.text = "Closed Now"
                infoView.openLabel.textColor = UIColor.redColor()
            }
            
            self.placeName = placeMarker.place.name
            self.placeAddress = placeMarker.place.address
            
            infoView.iconView.image = placeMarker.place.icon
            self.view.bringSubviewToFront(placeOptionsView)
            self.showSearchFields = false
            return infoView
        } else {
            return nil
        }
    }

}