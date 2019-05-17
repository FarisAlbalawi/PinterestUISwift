# PinterestUISwift

[![CI Status](https://img.shields.io/travis/farisalbalawi/PinterestUISwift.svg?style=flat)](https://travis-ci.org/farisalbalawi/PinterestUISwift)
[![Version](https://img.shields.io/cocoapods/v/PinterestUISwift.svg?style=flat)](https://cocoapods.org/pods/PinterestUISwift)
[![License](https://img.shields.io/cocoapods/l/PinterestUISwift.svg?style=flat)](https://cocoapods.org/pods/PinterestUISwift)
[![Platform](https://img.shields.io/cocoapods/p/PinterestUISwift.svg?style=flat)](https://cocoapods.org/pods/PinterestUISwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PinterestUISwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PinterestUISwift'
```

## Usage

```swift
import PinterestUISwift

class ViewController: UIViewController, collectionViewFlowDataSource{
    
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
}
```
## functions
### Height of the items at index path:
```swift
   func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGFloat {
       // take image height and return the height
        let height = Float.random(in: 80 ..< 400)
        return CGFloat(height)
    }
  ```  
### number of columns: 
```swift
   func numberOfCols(at section: Int) -> Int {
        return 2
        
    }
```

### space of columns: 
```swift
   func spaceOfCells(at section: Int) -> CGFloat{
        return 12
    }
```

### UICollectionview Section Inset: 
```swift
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
    }
```
### size Of Header: 
```swift
   func sizeOfHeader(at section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 150)
    }
```
### height Of Additional Content: 
```swift
 func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
```


## Author

Faris Albalawi, developer.faris@gmail.com

## License

PinterestUISwift is available under the MIT license. See the LICENSE file for more info.
