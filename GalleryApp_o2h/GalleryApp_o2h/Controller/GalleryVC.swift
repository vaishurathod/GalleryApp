//
//  GalleryVC.swift
//  GalleryApp_o2h
//
//  Created by Apple on 03/02/24.
//

import UIKit
import SDWebImage

class GalleryVC: UIViewController {
    
    // --------------------------------------------------------------------------
    // MARK: - IBOutlets
    // --------------------------------------------------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    // --------------------------------------------------------------------------
    // MARK: - Variables
    // --------------------------------------------------------------------------
    var imgArr = [String]()
    var totalCount = 10
    var currentPage = 1
    var isSign = 0
    
    // --------------------------------------------------------------------------
    // MARK: - Abstract Method
    // --------------------------------------------------------------------------
    class func viewController() -> GalleryVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
    }
    
    // --------------------------------------------------------------------------
    // MARK: - View Life Cycle Methods
    // --------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = true
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        fetchImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalCount = 10
        currentPage = 1
        fetchImages()
    }
}

// --------------------------------------------------------------------------
// MARK: - Custom methods & Api call
// --------------------------------------------------------------------------

extension GalleryVC{
    
    func fetchImages(){
        var viewSpinner: UIView?
        DispatchQueue.main.async {
            viewSpinner = IPLoader.showLoaderWithBG(viewObj: self.view, boolShow: true, enableInteraction: false)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        DispatchQueue.global().async {
            if let allGalleryData = GalleryData.fetchAllRecords() {
                // Assuming allGalleryData contains the entire set of images
                let allImageUrls = allGalleryData.flatMap { $0.imgUrls ?? [] }
                
                let startIndex = (self.currentPage - 1) * self.totalCount
                let endIndex = min(startIndex + self.totalCount, allImageUrls.count)
                
                if startIndex < allImageUrls.count {
                    let currentPageData = Array(allImageUrls[startIndex..<endIndex])
                    
                    print("Fetched image: \(currentPageData)")
                    
                    DispatchQueue.main.async {
                        IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: self.view)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.imgArr.append(contentsOf: currentPageData)
                        self.collectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: self.view)
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: self.view)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
}

// --------------------------------------------------------------------------
// MARK: - Actions
// --------------------------------------------------------------------------

extension GalleryVC{
    
    @IBAction func btnProfileAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = ProfileVC.viewController()
            vc.isSign = self.isSign
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


// --------------------------------------------------------------------------
// MARK: - CollectionView Delegate and Datasource methods
// --------------------------------------------------------------------------
extension GalleryVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        if indexPath.row < imgArr.count {
            cell.imgView.sd_setImage(with: URL(string: self.imgArr[indexPath.row]))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.numberOfSections > 0 {
            let lastSection = collectionView.numberOfSections - 1
            let lastRow = collectionView.numberOfItems(inSection: lastSection) - 1
            
            if indexPath.section == lastSection && indexPath.row == lastRow {
                let nextPage = (imgArr.count / totalCount) + 1
                if nextPage <= 10 {
                    currentPage += 1
                    fetchImages()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size
        return CGSize(width: (size.width - 5 * 10)/2, height: 150)
    }
}
