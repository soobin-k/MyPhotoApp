//
//  AlbumDetailViewController.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/05.
//

import UIKit
import Photos

class AlbumDetailViewController: UIViewController {
    
    //MARK: - Property
    // 앨범 콜렉션
    var albumCollection = PHAssetCollection()

    // 앨범 제목
    var albumTitle = String()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: - Action
    func setUI(){
        navigationItem.title = albumTitle
    }
}


