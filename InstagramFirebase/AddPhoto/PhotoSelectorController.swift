//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/12/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Photos



class PhotoSelectorController: UICollectionViewController {
    
    
    
    //MARK:- Properties
    var activityView: UIActivityIndicatorView?
    var images = [UIImage]()
    var selectedImage:UIImage?
    var assets = [PHAsset]()
    var header:PhotoSelectorHeader?
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        setupNavigationButton()
        registerCells()
        fetchPhotos()
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        true
    }

    
    
    
}



// MARK: UICollectionViewDataSource
extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 ) / 4
        return CGSize(width: width, height: width)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoSelectorCell
        cell.PhotoImageView.image = images[indexPath.item]
        
                
        return cell
    }
}

//MARK:- CollectionView Deleget
extension PhotoSelectorController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
       let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        self.collectionView.reloadData()
        
    }
}



//MARK:- CollectionView Header
extension PhotoSelectorController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! PhotoSelectorHeader
        self.header = cell
        let imageManger = PHImageManager.default()
        if let selectedImage = selectedImage {
            if let index = self.images.lastIndex(of:selectedImage){
                let selectedAsset = self.assets[index]
                let targetSize = CGSize(width: 600, height: 600)
                imageManger.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    if let image = image {
                    cell.HeaderPhotoImage.image = nil
                    cell.HeaderPhotoImage.image = image
                    }
                }
            }
        }
    
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}








//MARK:- Private functions
extension PhotoSelectorController{
   
    //fetch local photos method
    fileprivate func fetchPhotos(){
        showActivityIndicator()
        DispatchQueue.global(qos: .background).async {
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with:.image , options: fetchOptions)
        allPhotos.enumerateObjects { (asset, count, stop) in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 10, height: 10)
            let options = PHImageRequestOptions()
            let sortDiscriptors = NSSortDescriptor(key: "creationDate", ascending: false)
            fetchOptions.sortDescriptors = [sortDiscriptors]
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                if let image = image {
                    self.images.append(image)
                    self.assets.append(asset)
                    
//                    if self.selectedImage == nil {
                        self.selectedImage = self.images.last
//                    }
                }
                if count == allPhotos.count - 1 {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        }

    }
    
    
    
    fileprivate func registerCells(){
        self.collectionView!.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "cellId")
        self.collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    fileprivate func setupNavigationButton(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handelCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handelNext))
    }
    
    
    @objc fileprivate func handelCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handelNext(){
        SharePhotoController.selectedImage = header?.HeaderPhotoImage.image
        navigationController?.pushViewController(SharePhotoController(), animated: true)
    }
    
    
    fileprivate func showActivityIndicator() {
         activityView = UIActivityIndicatorView(style: .gray)
         activityView?.center = self.view.center
         self.view.addSubview(activityView!)
         activityView?.startAnimating()
     }
     
    fileprivate func hideActivityIndicator(){
         if (activityView != nil){
             activityView?.stopAnimating()
         }
     }
}
