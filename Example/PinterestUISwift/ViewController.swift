//
//  ViewController.swift
//  PinterestUISwift
//
//  Created by farisalbalawi on 05/17/2019.
//  Copyright (c) 2019 farisalbalawi. All rights reserved.
//

import UIKit
import PinterestUISwift


func RandomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)
}

func numberCols() -> Int {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return 2
    case .pad:
        return 4
    case .unspecified:
        return 2
    case .tv:
        return 2
    case .carPlay:
        return 2
    @unknown default:
        fatalError()
    }
}



class ViewController: UIViewController {
    
    
    // MARK: Variables
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = collectionViewLayout(delegate: self)
        if #available(iOS 10.0, *) {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            // Fallback on earlier versions
        }
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height), collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        let nib:UINib = UINib(nibName: "Header", bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}




// collection View
extension ViewController: collectionViewFlowDataSource {
    
    func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGFloat {
        let height = Float.random(in: 80 ..< 400)
        return CGFloat(height)
    }
    
    
    func numberOfCols(at section: Int) -> Int {
        return numberCols()
        
    }
    
    func spaceOfCells(at section: Int) -> CGFloat{
        return 12
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
    }
    
    func sizeOfHeader(at section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
}



// MARK: Data source
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        cell.layer.backgroundColor = RandomColor().cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // Mark: header config
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier:"Header", for: indexPath) as! Header
            
            
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    
}
