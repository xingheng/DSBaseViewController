# DSBaseViewController

[![Version](https://img.shields.io/cocoapods/v/DSBaseViewController.svg?style=flat)](http://cocoapods.org/pods/DSBaseViewController)
[![License](https://img.shields.io/cocoapods/l/DSBaseViewController.svg?style=flat)](http://cocoapods.org/pods/DSBaseViewController)
[![Platform](https://img.shields.io/cocoapods/p/DSBaseViewController.svg?style=flat)](http://cocoapods.org/pods/DSBaseViewController)



## What

The 'DS' prefix is short for Data State, also stand for my team name with Dragon Source. DSBaseViewController brings the convenience for UIViewController subclasses to maintain the subviews' construction and data source management, it extends a core protocol with overriding methods of UIViewController, conforming the protocol for the subclasses will get the beautiful magic.



## Why

I saw there are many developers wrote the funny code in their projects, for example, to build a serial of subviews for view controllers, to load data (from network) for view controllers, the common solution is creating some methods like `- (void)configUI`, `- (void)loadData` and call them in `viewDidLoad`. That's okay for a sample project, but not for a team project, I think.

Taking a long-term maintenance of a team project into consideration, suppose there are a few developers working together in a project, every one has his naming rule. It would have many methods to build subviews for view controllers, such as `- (void)configUI`, `- (void)setupUI`, `- (void)buildSubviews`, etc. That's terrible! It's the world of criminal without rules.

## How

With the *DSBaseViewController* class as super class, it externs the original methods of UIViewController with protocol *BuildViewDelegate*.


``` objective-c
- (void)buildSubview:(UIView *)containerView controller:(BaseViewController *)viewController
```

*Used for build subviews for view controller.*

```objective-c
- (void)loadDataForController:(BaseViewController *)viewController
```

*Used for load data for view controller.*

```objective-c
- (void)tearDown:(BaseViewController *)viewController
```

*Used for unload data for view controller.*

```objective-c
- (BOOL)shouldInvalidateDataForController:(BaseViewController *)viewController
```

*Used for mark the data valid status to load data for view controller.*



All of these delegate methods will be called automatically in view controller's life cycle. Technically, they should NOT be called directly in internal implementation in subclasses' view controller. This is the God, the rule!



However, it isn't still a perfect way to writing beautiful code (structure). **We need more naming rules, more moralities**.

1. Using the `#pragma mark -` for delegates, public methods, private methods, class starter.
2. Force the order of `#pragma mark -` like [this](Images/pragma_mark_preview.png).
3. Define the private method with prefix '_', like "\_refreshDataForView:".



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

DSBaseViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DSBaseViewController"
```

## Author

Will Han, xingheng.hax@qq.com

## License

DSBaseViewController is available under the MIT license. See the LICENSE file for more info.
