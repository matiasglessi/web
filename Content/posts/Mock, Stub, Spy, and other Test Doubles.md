---
title: Mock, Stub, Spy, and other Test Doubles
date: 2022-06-25 21:21
description: Brief review of the Mocking technique for testing, and the structures that can be used according to the need of the moment.
tags: testing
crossPosted: http://google.com.ar
pullRequest: http://google.com.ar
---

Many times we find ourselves looking for a way to simulate objects and/or dependencies of our classes or modules when testing. That's where mock test objects come in, which in popular jargon are often called “Mocks”. Although this is not incorrect since they are elements that “mimic” something else, the correct term is Test Doubles.
[In the words of Gerard Meszaros](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Code/dp/0131495054), Test Double is a generic term for any case where you replace a production object for testing purposes.

In this [article](http://xunitpatterns.com/Test%20Double.html), Gerard Meszaros introduced five types of Test Doubles: Dummy, Fake, Stub, Spy, Mock. We will see each one of them, and when its application is convenient.

To do this, we will follow this simple example:


```swift
typealias Days = Int
let REGISTERED_USER = "matiasglessi@gmail.com"

protocol EmailService {
    func sendEmail(to mail: String, subject: String)
}

protocol DatabaseService {
    func getDaysToExpiration() -> Days
}

class NotificationService {
    private let emailService: EmailService
    private let databaseService: DatabaseService
    
    init(emailService: EmailService, databaseService: DatabaseService) {
        self.emailService = emailService
        self.databaseService = databaseService
    }
    
    func validateStatus() {
        let days = databaseService.getDaysToExpiration()
        
        if isAboutToExpire(days){
            emailService.sendEmail(to: REGISTERED_USER,
                                   subject: "Your service is close to expiration.")
        }
    }
    
    private func isAboutToExpire(_ days: Days) -> Bool {
        days < 10
    }
}
```
This code shows the logic of a service called NotificationService, which is fed through dependency injection with two other services: EmailService and DatabaseService. Basically, the `validateStatus()` method evaluates how many days are left for the service to expire (using DatabaseService) and if it is less than 10, an email is sent to the user (using EmailService).

### Dummy

It is the simplest of all. They are objects that are passed from one place to another but are not used. They usually exist for the sole purpose of completing parameters or satisfying dependencies.

In this case, we can assume the need to validate the correct initialization of the NotificationService service. We could create dummy implementations of its dependencies as follows:

```swift
class DummyEmailService: EmailService {
    func sendEmail(to mail: String, subject: String) {
        fatalError("This service implementation should not be used.")
    }
}

class DummyDatabaseService: DatabaseService {
    func getDaysToExpiration() -> Days {
        fatalError("This service implementation should not be used.")
    }
}
```

As you can see, using these implementations would cause the application to crash. The use of some kind of exception or error generator (`NullPointerException`, `fatalError()`, etc) is a good practice to avoid its use in production code.


```swift
class NotificationServiceTests_DummyExample: XCTest {
 
    func test_onNotificationServiceInit_NotificationServiceIsNotNil() {
        let emailService = DummyEmailService()
        let databaseService = DummyDatabaseService()
        
        let notificationService = NotificationService(
            emailService: emailService,
            databaseService: databaseService
        )
        
        XCTAssertNotNil(notificationService)
    }
}
```

In order to test a function of the NotificationService service, the corresponding Test Double must exist for EmailService and for DatabaseService. Since they have no use in the `test_onNotificationServiceInit_NotificationServiceIsNotNil()` test case, it's okay to implement it as Dummy.

### Stub

Stubs are objects that provide predefined responses. They are usually used to define a specific type of response expected from the object/dependency that is being simulated, in order to guide the test in a certain direction.
Following the same example, suppose we need to validate different responses from the database. We could create Stubs in the following way:

```swift
class CloseToExpirationDatabaseServiceStub: DatabaseService {
    func getDaysToExpiration() -> Days {
        5
    }
}

class NotCloseToExpirationDatabaseServiceStub: DatabaseService {
    func getDaysToExpiration() -> Days {
        135
    }
}
```

In this case, we create two different Stubs with the possible situations that can occur. Thus, using the first, we could validate what should happen when the number of days is less than 10, and with the second, the case when the result is greater.
Instead of performing a validation, a login, or a search in a real database, (to give some examples) we return what is useful for that test case: a specific boolean, a value, a valid object or invalid, etc.

Performing the actual operation, by calling the actual services, is possible, but it takes time and requires configuration. If there is a bug in the called service, the tests fail for the wrong reasons. And after all, it is an unnecessary coupling.

### Spy

Spy objects are those that, in addition to being Stubs (that is, they return the desired predefined information) also record data on how they were called in some way.

The stored information can be given through variables that store boolean information if the call was made or not, an integer value about the number of times said call was made, or any type of argument that you are interested in saving.

In the case of EmailService, we can generate a Spy as follows:

```swift
class SpyEmailService: EmailService {
    
    var emailServiceWasCalled: Bool = false
    
    func sendEmail(to mail: String, subject: String) {
        emailServiceWasCalled = true
    }
}
```
This Test Double will log the call to the `sendEmail(mail:subject:)` method via the `emailServiceWasCalled` boolean property.

Thus, we can use the Spy in the following context:

```swift
class NotificationServiceTests_SpyExample: XCTest {
 
    func test_onNotificationServiceStatusValidationCloseToExpiration_EmailServiceIsCalled() {
        let emailService = SpyEmailService()
        let databaseService = CloseToExpirationDatabaseServiceStub()
        
        let notificationService = NotificationService(
            emailService: emailService,
            databaseService: databaseService
        )
        
        notificationService.validateStatus()
        
        XCTAssertTrue(emailService.emailServiceWasCalled)
    }
}
```
The `test_onNotificationServiceStatusValidationCloseToExpiration_EmailServiceIsCalled()` test creates the [SUT](https://en.wikipedia.org/wiki/System_under_test) from the Stub we saw earlier for the DatabaseService and a Spy for the EmailService, which will save the information on whether the service was called or not. Since the Stub returns a default value less than 10, when calling `validateStatus()` the mailing service should have been called, exactly what is evaluated in the following XCTAssert statement.

But beware! The more internal information we are storing about how our module works, the greater the risk of coupling to the system implementation. And that can lead to brittle tests (that fail for reasons unrelated to the test).

### Mock

Mocks are objects that record the calls they receive and analyze the behavior. When we are in the verification part of the test, we can check that all the expected actions were carried out.

They know what is being tested, which is why they are said to assess behavior. They are Spy type objects since they spy on the behavior of the module being tested. And it is the mock itself that knows what behavior to expect.
In the example, we can perform a Mock by moving the verification to the Test Double's own code:

```swift
class EmailServiceMock: EmailService {
    
    private var emailServiceWasCalled: Bool = false
    private var emailsSentCount = 0
    
    func sendEmail(to mail: String, subject: String) {
        emailServiceWasCalled = true
        emailsSentCount += 1
    }
    
    func verify() -> Bool {
        emailServiceWasCalled && emailsSentCount == 1
    }
}
```

The EmailServiceMock acts as a Spy, saving information regarding the call made. This information is then validated in the mock itself, in its `verify()` method, where it evaluates that the behavior has been as expected: in this case, that the service was actually called and that a single email was sent.
This would be the evaluation, analyzing the result of the `verify()` method in the EmailServiceMock itself:

```swift
func test_onNotificationServiceStatusValidationCloseToExpiration_EmailServiceIsCalledCorrectly() {
    let emailService = EmailServiceMock()
    let databaseService = CloseToExpirationDatabaseServiceStub()
    
    let notificationService = NotificationService(
        emailService: emailService,
        databaseService: databaseService
    )
    
    notificationService.validateStatus()
    
    XCTAssertTrue(emailService.verify())
}
```

We use mocks when we don't want to call production code or when there is no easy way to verify that the system actually did something. The only thing we can do for these cases is to verify that the service was called and works (and what that implies, which may be making calls to other mocked services).

### Fake

Fake objects are those that have working implementations, but usually have some shortcut or structure that makes them unfeasible for production use. Unlike any other type of Test Double, they have real business behavior, which can be complex to manage (even requiring their own tests) and dangerous, since they can easily be used in production.

In this case, we can create a Fake as follows:

```swift
class FakeDatabaseService: DatabaseService {
    
    var daysToExpiration: Int = 0
    
    func getDaysToExpiration() -> Days {
        return daysToExpiration
    }
    
    func updateDaysToExpiration(_ days: Days) {
        daysToExpiration = days
    }
}
```

This FakeDatabaseService will be an implementation of the functional DatabaseService service, since it is using a variable in memory to store the information obtained. [As Martin Fowler mentions in InMemoryTestDatabase](https://martinfowler.com/bliki/InMemoryTestDatabase.html), Fake databases serve as a replacement for database access in test cases. Beyond the fact that there may be cases where an in-memory database is actually used, its use as a Test Double to test dependencies results in a fast and efficient testing practice, since long and slow setups are avoided, as usually required by databases configurations.

There are several types of Test Doubles with different intentions. Confusing and mixing your implementations can influence test design, and increase its brittleness. That is why it is of great importance to understand the types that exist and when to use each one.


#### References

- [martinfowler.com: Test Double](https://martinfowler.com/bliki/TestDouble.html)
- [martinfowler.com: Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html)
- [martinfowler.com: InMemoryTestDatabase](https://martinfowler.com/bliki/InMemoryTestDatabase.html)
- [amazon.com: xUnit Test Patterns Book](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Code/dp/0131495054)
- [xunitpatterns.com: Test Double](http://xunitpatterns.com/Test%20Double.html)
- [cleancoder.com: The Little Mocker](https://blog.cleancoder.com/uncle-bob/2014/05/14/TheLittleMocker.html)

