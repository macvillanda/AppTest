# Appetiser Test

### Persistence
The app uses [Unrealm](https://github.com/arturdev/Unrealm), a wrapper around [Realm](https://realm.io/docs/swift/latest/) to support native Swift classes and structs. Realm was used due to ease of use compared to SQLite or CoreData. UserDefaults was ruled out because of the complexity of saving and retrieving structs also it is only good for simple data ojects. Realm is a NOSql type of DB which elimitates complex SQL queries and could scale much better that SQLite or CoreData.
The app will save two sets of data. One is the search data which will be used by each screen of the app. The other one is the navigation state where it save the current navigation stack of the user.

### Architecture
The app uses the architecture 
![MVVM-C](https://marcosantadev.com/wp-content/uploads/mvvm-c.jpg?v=1)

Every viewcontroller will have a viewmodel. The **Viewmodel** will be reponsible for the business logic and will feed the data to the view. The **Viewcontroller** is just a view whereas it's only reponsibility is to render the data provided by the **ViewModel**. The **Model** is just a struct/class that represents the data that will be retrieved in the apis. The **Coordinator** will be responsible for routing in the app like pushing, presenting and dismissing viewcontrollers. The complete the binding between the **ViewModel** and **View** the app uses [RXSwift](https://github.com/ReactiveX/RxSwift) to bind and make the **ViewModel** data reactive so that the view will be notified of changes instantaneously.
