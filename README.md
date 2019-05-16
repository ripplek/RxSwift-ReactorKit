# RxSwift-MVVM

这个项目是入坑[RxSwift](https://github.com/ReactiveX/RxSwift)以来的一些收获，历经多个真实项目的实践。我也一直在为写出简洁易懂的代码而努力学习和实践，当中难免有不足之处希望得到社区开源爱好者的指点，期待在与你的探讨中也能获得一些收获

## 项目介绍

- **iOS 界面业务逻辑**

	```swift
	/*
	 ViewController(action)
	 		 ⏬ 
	 Reactor(transform(action:))
	 		 ⏬
 	 Reactor(mutate(action:)) 
 	 		 ⏬
	 Reactor(transform(mutation:))
	 		 ⏬
	 Reactor(reduce(state: State, mutation: Mutation)) 
	 		 ⏬
	 Reactor(transform(state:))
	 		 ⏬
	 ViewController(state)
	*/
	
	func bind(reactor: RepoListViewReactor) {
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repos }
            .filterEmpty()
            .distinctUntilChanged()
            .map { [Section(model: (), items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
	
	```

- **Utility 通用工具集合**
- **MVVMBase 项目基类**
- **Networking 网络层封装**

	```swift
	/*
	 service
	 	⏬
	 API(MVVMTargetType)
	 	⏬
	 Moya(TargetType)
	*/ 
		service
            .repos(username: currentState.name, page: 1)
            .asObservable()
            .map(Mutation.setRepos)
	```
- **Namespace 链式语法调用**

	```swift
		tableView
            .mvvm.adhere(toSuperView: view)
            .mvvm.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
	```
	
**如果你觉得还不错那就给个star吧O(∩_∩)O~**

## 项目依赖
* [**RxSwift/RxCocoa**](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift
* [**RxOptional**](https://github.com/RxSwiftCommunity/RxOptional) - RxSwift extensions for Swift optionals and "Occupiable" types
* [**RxDataSources**](https://github.com/RxSwiftCommunity/RxDataSources) - UITableView and UICollectionView Data Sources for RxSwift (sections, animated updates, editing ...)
* [**Moya/RxSwift**](https://github.com/Moya/Moya) - Network abstraction layer written in Swift
* [**CocoaLumberjack/Swift**](https://github.com/CocoaLumberjack/CocoaLumberjack) - A fast & simple, yet powerful & flexible logging framework for Mac and iOS
* [**Kingfisher**](https://github.com/onevcat/Kingfisher) - A lightweight, pure-Swift library for downloading and caching images from the web
* [**SnapKit**](https://github.com/SnapKit/SnapKit) - A Swift Autolayout DSL for iOS & OS X
* [**MJRefresh**](https://github.com/CoderMJLee/MJRefresh) - An easy way to use pull-to-refresh
* [**ReactorKit**](https://github.com/ReactorKit/ReactorKit) - A framework for a reactive and unidirectional Swift application architecture


> ReactorKit is a combination of [Flux](https://facebook.github.io/flux/) and [Reactive Programming](https://en.wikipedia.org/wiki/Reactive_programming). The user actions and the view states are delivered to each layer via observable streams. These streams are unidirectional: the view can only emit actions and the reactor can only emit states.

>> <p align="center">
  <img alt="flow" src="https://cloud.githubusercontent.com/assets/931655/25073432/a91c1688-2321-11e7-8f04-bf91031a09dd.png" width="600">
</p>

> ### View

> A *View* displays data. A view controller and a cell are treated as a view. The view binds user inputs to the action stream and binds the view states to each UI component. There's no business logic in a view layer. A view just defines how to map the action stream and the state stream.

> To define a view, just have an existing class conform a protocol named `View`. Then your class will have a property named `reactor` automatically. This property is typically set outside of the view.

> ```swift
> class ProfileViewController: UIViewController, View {
>  var disposeBag = DisposeBag()
> }
> 
> profileViewController.reactor = UserViewReactor() // inject reactor
> ```

> When the `reactor` property has changed, `bind(reactor:)` gets called. Implement this method to define the bindings of an action stream and a state stream.

> 
> ```swift
> func bind(reactor: ProfileViewReactor) {
>   // action (View -> Reactor)
>   refreshButton.rx.tap.map { Reactor.Action.refresh }
>     .bind(to: reactor.action)
>     .disposed(by: self.disposeBag)
> 
>   // state (Reactor -> View)
>   reactor.state.map { $0.isFollowing }
>     .bind(to: followButton.rx.isSelected)
>     .disposed(by: self.disposeBag)
> }
> ```
> 

> ### Reactor

> A *Reactor* is an UI-independent layer which manages the state of a view. The foremost role of a reactor is to separate control flow from a view. Every view has its corresponding reactor and delegates all logic to its reactor. A reactor has no dependency to a view, so it can be easily tested.

> Conform to the `Reactor` protocol to define a reactor. This protocol requires three types to be defined: `Action`, `Mutation` and `State`. It also requires a property named `initialState`.

> ```swift
> class ProfileViewReactor: Reactor {
>   // represent user actions
>   enum Action {
>     case refreshFollowingStatus(Int)
>     case follow(Int)
>   }
> 
>  // represent state changes
>   enum Mutation {
>     case setFollowing(Bool)
>   }
> 
>  // represents the current view state
>   struct State {
>     var isFollowing: Bool = false
>   }
> 
>  let initialState: State = State()
> }
> ```

> An `Action` represents a user interaction and `State` represents a view state. `Mutation` is a bridge between `Action` and `State`. A reactor converts the action stream to the state stream in two steps: `mutate()` and `reduce()`.

>> <p align="center">
  <img alt="flow-reactor" src="https://cloud.githubusercontent.com/assets/931655/25098066/2de21a28-23e2-11e7-8a41-d33d199dd951.png" width="800">
</p>