//
//  ProfileVC.swift
//  GalleryApp_o2h
//
//  Created by Apple on 03/02/24.
//

import UIKit
import GoogleSignIn

class ProfileVC: UIViewController{
    
    // --------------------------------------------------------------------------
    // MARK: - IBOutlets
    // --------------------------------------------------------------------------
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignout: UIButton!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    // --------------------------------------------------------------------------
    // MARK: - Variables
    // --------------------------------------------------------------------------
    
    var isSign = 0
    
    
    // --------------------------------------------------------------------------
    // MARK: - Abstract Method
    // --------------------------------------------------------------------------
    class func viewController() -> ProfileVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
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
// MARK: - Custom Methods
// --------------------------------------------------------------------------

extension ProfileVC {
    
    func setup(){
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        btnSignout.layer.borderWidth = 1
        btnSignout.layer.borderColor = UIColor.systemRed.cgColor
        btnSignout.layer.cornerRadius = 10
        self.fetchallData()
    }
    
    func fetchallData(){
        if let allUserData = UserData.fetchAllRecords() {
            for userData in allUserData {
                lblLastName.text = "Last Name :- \(userData.lname ?? "")"
                lblEmail.text = "Email :- \(userData.email ?? "")"
                lblFirstName.text = "First Name:- \(userData.fname ?? "")"
                
                if let imageUrl = userData.imgUrl, let url = URL(string: imageUrl) {
                    DispatchQueue.global().async {
                        do {
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.imgProfile.image = image
                            }
                        } catch {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            print("Error fetching records")
        }
    }
    
    
    
    func signOut() {
        // Create an alert controller
        let alertController = UIAlertController(title: "GalleryApp_o2h", message: "Are you sure want to signout?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            GIDSignIn.sharedInstance().signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserData.deleteAllRecords()
            GalleryData.deleteAllRecords()
            
            if self.isSign == 0{
                if let vc = self.navigationController?.viewControllers.filter({$0.isKind(of: ViewController.self)}).last {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            } else {
                let vc = ViewController.viewController()
                let navC = UINavigationController(rootViewController: vc)
                navC.navigationBar.isHidden = true
                UIApplication.shared.windows.first?.rootViewController = navC
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// --------------------------------------------------------------------------
// MARK: - Actions
// --------------------------------------------------------------------------
extension ProfileVC{
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignOutAction(_ sender: UIButton) {
        signOut()
        
    }
}
