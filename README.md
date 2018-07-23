# TLPageView

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/ysCharles/TLPageView/master/LICENSE)
[![Pods Versions](https://img.shields.io/cocoapods/v/TLPageView.svg?style=flat)](http://cocoapods.org/pods/TLPageView)
[![CI Status](http://img.shields.io/travis/ysCharles/TLPageView.svg?style=flat)](https://travis-ci.org/ysCharles/TLPageView)
[![Swift Version Compatibility](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat-square)](https://developer.apple.com/swift)
[![swiftyness](https://img.shields.io/badge/pure-swift-ff3f26.svg?style=flat)](https://swift.org/)
[![Swift Version](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org)
[![GitHub stars](https://img.shields.io/github/stars/ysCharles/TLPageView.svg)](https://github.com/ysCharles/TLPageView/stargazers)

## Installation

### Manually

* clone this repo.
* Simply drop the `Sources` folder into your project.
* Enjoy！ 

### Cocoapods

`TLPageView` is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'TLPageView'
```

### Carthage

```ruby
github "ysCharles/TLPageView"
```

## Usage

```swift
import TLPageView

var colors : [UIColor] = [UIColor.yellow,UIColor.red,UIColor.brown,UIColor.blue]
    var titles : [String] = ["不仅仅是喜欢", "歌在飞", "小情歌", "回忆总想哭", "遥远的歌", "双节棍", "叶子", "天空中最亮的星", "稻香", "花桥流水"]
lazy var rightItem: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        btn .addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.setImage(UIImage(named: "More"), for: .normal)
        btn.setImage(UIImage(named: "More"), for: .highlighted)
        return btn
    }()

override func viewDidLoad() {
    super.viewDidLoad()
    var controllers = [UIViewController]()
        for i in 0..<10{
            let controller = UIViewController()
            controller.title = titles[i]//"测试中哈哈哈\(i)"
            controller.view.backgroundColor = colors[i % 4]
            controllers.append(controller)
        }
        
        let pageView = TLPageView(viewControllers: controllers, pageViewOptions:[.menuHeight(50),.menuItemMargin(15), .rightItem(rightItem)])
        view.addSubview(pageView)
    pageView.frame = self.view.bounds
}

//
public enum TLPageViewOption {
    case menuHeight(CGFloat) // menuBar height
    
    case menuBottmonLineHeight(CGFloat) //bottom line height
    case menuBottomLineColor(UIColor)
    
    case menuItemFont(UIFont)
    case menuItemColor(UIColor)
    case menuItemSelectedColor(UIColor)
    case menuItemMargin(CGFloat)
    
    case leftItem(UIView)
    case rightItem(UIView)
    
    case separatorLineColor(UIColor)
    case separatorLineHeight(CGFloat)
    
    case menuBackgroundColor(UIColor)
}
```

## License

`TLPageView` is available under the MIT license. See the `LICENSE` file for more info.