# Herowser
Case Study

Herowser is hero list from Marvel's developer API. You can see hero list and their comics.  

### Installation:
Pods are included to repository just run application. You can use your own public and private API keys in APICredentialGenerator.

### Project Structure:
Used MVVM-C with `State` for this case since MVVM-C is requirement. I prefer MVVM-R pattern on my projects. MVVM-R is classic MVVM pattern with `State` and `Router` extensions. State is our data container which controlled by view model. Router is handling routing on view controller. For further information please check [this blog post](https://medium.com/commencis/using-redux-with-mvvm-on-ios-18212454d676). 

I like to use stackview in dynamic interfaces for easier show/hide handling.

Used combine for observing notifications and network request in detail.

You can check unit tests for FavoriteManager operations.

### Third-party Libs:
- `Alamofire` for networking
- `KingFisher` image download & cache operations

### Things I would change If I had more time:
- UI improvements (very basic due to time constraints)
- Transition between list and detail scenes
- Refactor design pattern with more dependency injection
- Handling missin error and loading indicators if any left 
- Collection view for hero list
- SwiftUI is an option too

### Things needed for production:
- Crash tracking tool.
- Analytics tool for tracking user behaviour.
