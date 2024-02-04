//
//  ViewController.swift
//  GalleryApp_o2h
//
//  Created by Apple on 03/02/24.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {
    
    
    // --------------------------------------------------------------------------
    // MARK: - IBOutlets
    // --------------------------------------------------------------------------
    @IBOutlet weak var btnSignin: UIButton!
    
    
    // --------------------------------------------------------------------------
    // MARK: - Variables
    // --------------------------------------------------------------------------
    
    
    
    
    // --------------------------------------------------------------------------
    // MARK: - Abstract Method
    // --------------------------------------------------------------------------
    class func viewController() -> ViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    
    // --------------------------------------------------------------------------
    // MARK: - View Life Cycle Methods
    // --------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    
}

// --------------------------------------------------------------------------
// MARK: - Action
// --------------------------------------------------------------------------

extension ViewController{
    // Start Google Sign-In
    @IBAction func signInBtnAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}


// --------------------------------------------------------------------------
// MARK: - Custom Methods
// --------------------------------------------------------------------------

extension ViewController {
    
    func setup(){
        GIDSignIn.sharedInstance().clientID = "612593034455-ai4h6jjrgf34o8po4r5rqa3vl74laeju.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        btnSignin.layer.borderWidth = 1
        btnSignin.layer.borderColor = UIColor.systemRed.cgColor
        btnSignin.layer.cornerRadius = 10
    }
}


// --------------------------------------------------------------------------
// MARK: - Google sign delegate method
// --------------------------------------------------------------------------
extension ViewController{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google Sign-In Error: \(error.localizedDescription)")
            return
        }
        
        print(user.userID ?? "", "User Detail")
        // Handle successful sign-in
        let userId = user.userID
        let fullName = user.profile?.name
        let givenName = user.profile?.givenName
        let familyName = user.profile?.familyName
        let email = user.profile?.email
        let imgUrl = user.profile?.imageURL(withDimension: 120)?.absoluteString
        
        var saveData = UserDataModel()
        saveData.email = email
        saveData.fname = givenName
        saveData.lname = familyName
        saveData.imgUrl = imgUrl
        saveData.id = userId
        UserData.saveRecord([saveData])
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        self.getImageApiCall()
    }
}

// --------------------------------------------------------------------------
// MARK: - api calling
// --------------------------------------------------------------------------

extension ViewController {

    func getImageApiCall() {
        
        var viewSpinner: UIView?
        DispatchQueue.main.async {
            viewSpinner = IPLoader.showLoaderWithBG(viewObj: self.view, boolShow: true, enableInteraction: false)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        
        let galleryUrl = "https://api.unsplash.com/photos/?client_id=S4wD_5iD7NuNzm5XlAvpxw3PUj1RST4Gm9wR7vNKf_Q&order_by=ORDER&per_page=50"
        if let url = URL(string: galleryUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: self.view)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
                if let error = error {
                    print("Error: \(error)")
                    
                }else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    do{
                        let decoder = JSONDecoder()
                        let picInfo = try decoder.decode([ImageInfo].self, from: data)
                        let photoUrls = picInfo.compactMap { $0.urls.regular }
                        let saveGallery = GalleryDataModel(imgUrls: photoUrls, id: "\(photoUrls.count)")
                        GalleryData.saveRecord([saveGallery])
                        
                        DispatchQueue.main.async {
                            let vc = GalleryVC.viewController()
                            vc.isSign = 0
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
        
    }
}


struct ImageInfo: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
}
