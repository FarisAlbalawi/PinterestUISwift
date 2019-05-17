//
//  collectionViewLayout.swift
//  PinterestUISwift
//
//  Created by Faris Albalawi on 5/17/19.
//

import UIKit


public protocol collectionViewFlowDataSource: class{
    func numberOfCols(at section: Int) -> Int
    func sizeOfItemAtIndexPath(at indexPath : IndexPath) -> CGFloat
    func spaceOfCells(at section: Int) -> CGFloat
    func sectionInsets(at section: Int) -> UIEdgeInsets
    func sizeOfHeader(at section: Int) -> CGSize
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat
    
}

extension collectionViewFlowDataSource{
    func spaceOfCells(at section: Int) -> CGFloat{
        return 0
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.zero
    }
    
    func sizeOfHeader(at section: Int) -> CGSize{
        return CGSize.zero
    }
    
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
}


typealias ColY = (index: Int,colY: CGFloat)


struct ColPosition{
    
    var colYs: [ColY]
    
    var maxY: CGFloat{
        if let max = colYs.max(by: {$0.colY<$1.colY}){
            return max.colY
        }
        return 0
    }
}


let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = kScreenSize.width
let kScreenHeight = kScreenSize.height


open class collectionViewLayout: UICollectionViewFlowLayout {
    
    open weak var dataSourceDelegate : collectionViewFlowDataSource?
    
    open var collectionHeaderView: UIView?{
        willSet{
            collectionHeaderView?.removeFromSuperview()
        }
        didSet{
            collectionView?.reloadData()
        }
    }
    
    
    var layoutDict: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    var layoutHeaderViewInfo: [UICollectionViewLayoutAttributes] = []
    
    
    var colHeights:[ColPosition] = []
    
    public init(delegate: collectionViewFlowDataSource){
        dataSourceDelegate = delegate
        super.init()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var collectionViewContentSize : CGSize {
        if var max = colHeights.last?.maxY{
            if let delegate = self.dataSourceDelegate{
                max += delegate.sectionInsets(at: colHeights.count-1).bottom
            }
            return CGSize(width: kScreenWidth, height: max)
        }
        return CGSize.zero
    }
    
    override open func prepare() {
        
        layoutInit()
        
        if let sectionNum = collectionView?.numberOfSections{
            for section in 0..<sectionNum{
                guard let delegate = dataSourceDelegate else {continue}
                
                
                
                let originH = collectionHeaderView?.bounds.size.height ?? 0
                let preSectionH = section==0 ? originH : colHeights[section-1].maxY
                let preSectionInsetBottom = section==0 ? 0 : delegate.sectionInsets(at: section-1).bottom
                let currentSectionHeaderY = preSectionH + preSectionInsetBottom - (section==0 ? 0 : delegate.spaceOfCells(at: section-1))
                let headerSize = delegate.sizeOfHeader(at: section)
                let headerX = (kScreenWidth - headerSize.width)/2
                let headerH = headerSize.height
                
                
                let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttributes.frame = CGRect(x: headerX, y: currentSectionHeaderY, width: headerSize.width, height: headerSize.height)
                layoutHeaderViewInfo.append(headerAttributes)
                
                var rowSavers:[ColY] = []
                for index in 0..<delegate.numberOfCols(at: section){
                    
                    let currentSectionY = currentSectionHeaderY + headerH + delegate.sectionInsets(at: section).top
                    rowSavers.append((index,currentSectionY))
                }
                colHeights.append(ColPosition(colYs: rowSavers))
                
                
                if let itemNum = collectionView?.numberOfItems(inSection: section){
                    for item in 0..<itemNum{
                        let indexPath = IndexPath(item: item, section: section)
                        let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        itemAttributes.frame = frameForCellAtIndexPath(indexPath)
                        layoutDict.updateValue(itemAttributes, forKey: IndexPath(item: item, section: section))
                    }
                }
            }
        }
    }
    
    func frameForCellAtIndexPath(_ indexPath : IndexPath) -> CGRect {
        if let delegate = dataSourceDelegate {
            
            let sectionInsets = delegate.sectionInsets(at: indexPath.section)
            
            let space = delegate.spaceOfCells(at: indexPath.section)
            let colNum = CGFloat(delegate.numberOfCols(at: indexPath.section))
            let spaceNum = CGFloat(max(0, delegate.numberOfCols(at: indexPath.section)-1))
            let cellWidth = (kScreenWidth - sectionInsets.left - sectionInsets.right - space*spaceNum)/colNum
            
            let itemSize = delegate.sizeOfItemAtIndexPath(at: indexPath)
            var originX : CGFloat = 0.0
            var originY : CGFloat = 0.0
            var cellHeight : CGFloat = 0.0
            
            
            if itemSize > 0{
                cellHeight = itemSize
            }
            
            cellHeight += delegate.heightOfAdditionalContent(at: indexPath)
            
            
            if var min = colHeights[indexPath.section].colYs.min(by: {$0.colY<$1.colY}){
                originX = sectionInsets.left + cellWidth*CGFloat(min.index) + space*CGFloat(min.index)
                originY = min.colY
                min.colY += cellHeight + space
                
                colHeights[indexPath.section].colYs.remove(at: min.index)
                colHeights[indexPath.section].colYs.insert(min, at: min.index)
            }
            
            return CGRect(x: originX, y: originY, width: cellWidth, height: cellHeight)
        }
        return CGRect.zero
    }
    
    func layoutInit() {
        colHeights.removeAll()
        layoutDict.removeAll()
        layoutHeaderViewInfo.removeAll()
        
        //初始化headerView, Y为0
        guard let headerView = collectionHeaderView else {return}
        let headerWidth = headerView.bounds.size.width
        let headerX = (kScreenWidth - headerWidth)/2
        headerView.frame = CGRect(x: headerX, y: 0, width: headerWidth, height: headerView.bounds.size.height)
        collectionView?.addSubview(headerView)
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutDict[indexPath]
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result : [UICollectionViewLayoutAttributes] = []
        layoutDict.values.forEach({ (attribute) in
            if attribute.frame.intersects(rect) {
                result.append(attribute)
            }
        })
        layoutHeaderViewInfo.forEach { (attribute) in
            if attribute.frame.intersects(rect) {
                result.append(attribute)
            }
        }
        return result
    }
    
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= layoutHeaderViewInfo.count {
            return nil
        }
        return layoutHeaderViewInfo[indexPath.section]
    }
    
}
