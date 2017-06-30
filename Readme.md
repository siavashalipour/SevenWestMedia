### Installation: 
- please first do `pod install`
- then `open .xcworkspace`

### Libraries: 
- `RxSwift` and `RxCocoa`. Since I am using `MVVM` design pattern the best libraries for `iOS` to do the binding is `RxSwift` and it's `iOS` companion which is `RxCocoa`. `RxSwift` is basically the engine of the observable patterns in `Swift` and `RxCocoa` is the being built on top of that to add `UIKit` helpers for easier binding. Alternative for this is [ReactiveKit](https://www.google.com.au/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiy9eeTmeXUAhXDoJQKHVmkDm0QFggmMAA&url=https%3A%2F%2Fgithub.com%2FReactiveKit&usg=AFQjCNEGz55RWAX15yPU0pRhgYCEDewPfg) which indeed is a good library, however not powerful as `Rx` 
- `SDWebImage`. I have used this library to download thumbnail images Asynchronously. The good thing about this library is that it makes the code for setting the image very simple and readable, it also behind the hood does a nice caching as well. (i.e wouldn't download an image twice) 

### Architecture:
The design pattern I have used as mentioned earlier is `MVVM`. I have chosen this pattern since it makes the `ViewController` light weighted and separated the logics (mostly presentation and business logics) from the UI and the `ViewController`. As you can see in the project we have two ViewController that each one of them has their own ViewModel. The first ViewController `ChannelsViewController` is responsible for passing the ViewModel to the second viewController which is `ProgramViewController` since it instantiate the segue.
Then we have a separate Network layer that simply handles all the API and it works based on Observer pattern. 

### Minimum iOS version:
For the purpose of this App I have used minimum iOS version 9. Since iOS 11 is almost out and if we look out the stats currently more than %80 of the iPhone users are on 10+. 
