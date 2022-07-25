---
title: How to test your network connection requests in Swift using URLProtocol
date: 2022-07-23 00:00
description: A reliable and decoupled approach to testing network requests in Swift.
tags: testing, swift
---

In this post we will see how to test network requests using the perhaps not so well-known ***URL Loading System***, which intercepts requests made to the server.
To address our problem, we'll put some example code, assuming we have an implementation of this style in our productive code:

```swift
enum HTTPResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func get(from URL: URL, completion: @escaping (HTTPResult) -> Void)


class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
```
Here, we see a simple example of an interface to an HTTP client, called *HTTPClient*. This is made up of a single method that receives a URL and returns a result, which can be a success (with its corresponding *Data* and *Response*) or a failure (with an *Error*).

At the same time, it has a *URLSessionHTTPClient* implementation, which is responsible for communicating with the network. In our case we use *URLSession*, Apple's framework for network requests. As the focus is on understanding how to test this component of the system, we will leave an implementation already done, although this could be created from the test decisions, following *Test Driven Development (TDD)*.

First, we will see some alternative strategies to test implementation, which, although valid, have some disadvantages to consider, which will guide this post.

### Test real connections

One way to resolve this could be to test the connection for real. That is, the request is made to the backend, the response is obtained and it is evaluated if it is correct.
Although it is a valid option, we easily find several reasons why this strategy can be problematic: What if the backend is not developed yet? How do we handle the multiple causes for which a connection can fail? How to increase the duration of the test if the connection is too slow?
As we mentioned, although it is valid as a strategy, it is probably better to test the component in isolation.

Testing the service in an end-to-end way would be more useful if it took several components and how they are integrated.

### Mock with Subclasses

Since our implementation will use the [Apple URLSession](https://developer.apple.com/documentation/foundation/urlsession "Apple URLSession") framework to make connections to the server, one strategy would be to mock it, implementing a subclass of it that can spy on or capture the information needed to validate our tests. For example, we could add flags to check that the methods were called, or even save certain values such as URLs sent, or even the [URLSessionDataTask](https://developer.apple.com/documentation/foundation/urlsessiondatatask "URLSessionDataTask")  used (mocking these too), and validate that they are correct.

The problem with this strategy is that since it is a subclass of an Apple framework, there are many methods that we are not even aware of, which we should implement if we want to have full control of the class. Otherwise, our tests may end up using the methods of the parent class, which is dangerous since we would not be sure how it really works (or if network requests are actually made in this specific case). In each release even Apple can add new methods or update the old ones, changing how they work and causing our tests to fail.

### Mock with Protocols

A third option to address the issue is to create protocols that mimic the interfaces we are interested in mocking. For example we could create something like this:


```swift
protocol HTTPSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}
```

Thus, we would have a protocol very similar to *URLSession* (and another similar to *URLSessionDataTask*) that would only have the method that we are interested in mocking. In the test, our *SUT* will interact with the created protocol instead of the *URLSession*. This allows us to avoid assumptions about unknown methods and secret Apple implementations of how things work, in this case regarding the *URLSession* API. It also saves us the need to update these tests in the future in case Apple decides to update their methods since we only implement methods that we care about.

While this is another valid strategy, another problem makes this not the best solution: since we are mimicking the *URLSession* methods, there is a strong coupling with this API. Also, we're adding productive code just to satisfy our tests, which is definitely a wake-up call.

## Using the URL Loading System

According to Apple's definition, the [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system "URL Loading System") allows you to interact with URLs and communicate with servers using standard protocols (such as HTTP/HTTPS, for example) or with your **own protocols that you can create**.

<img src="/images/posts/urlloadingsystem/URLLoadingSystem.png" alt="URL Loading System diagram" width="450"/>

How does it work? Basically for every time a request is made, what happens behind the scenes is that there is a system (the URL Loading System) that processes it. As part of it, there is a type called *URLProtocol*, which is an **abstract class** that inherits from *NSObject*.


So if we create our own *URLProtocol* and register it, we can start intercepting URL Requests.
What is it for? As in this case, we could evaluate the component using a particular protocol, implement some kind of Cache, track information for Analytics, or even evaluate the performance of the requests.


For this, we only have to implement the methods of the abstract class *URLProtocol*, which although it sounds strange, is a class.
In this case, we will create a mock that implements this class and we will evaluate the validity of the tested requests, with the certainty that the requests are never made and no information is sent to any server, making the tests faster and more reliable.

### Creating our own protocol

Since the URL Loading System processes requests through different protocols, we will create our own. This subclass of *URLProtocol* will have the objective of intercepting the information that is transmitted and validating it.

```swift
    private class URLProtocolStub: URLProtocol { ... }
```

Since we want to intercept the information from a *URLRequest*, we could store this information in a structure within our *URLProtocolStub*. A dictionary could be a good option:

```swift
private static var stubs = [URL: Stub]()

private struct Stub {
    let data: Data?
    let response: URLResponse
    let error: Error?
}
```
Thus, when we are preparing our test case in the part of its preparation, we can save this information, and then perform the corresponding checks. Something like:

```swift
let urlProtocol = URLProtocolStub()
urlProtocol.stub(url: url, data: nil, response: nil, error: error)
}
```

Where the *stub(url: data: response: error:)* method of *URLProtocolStub* will have a form similar to this:

```swift
func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) {
    stubs[url] = Stub(data: data, response: response, error: error)
}
```

Now that we understand how we will store the information, we are ready to create a test case. We will test the error case, which is when the request has an error (error is not nil), and the client should return a *.failure(error)* result with the same error. It will be more or less like this:


```swift
func test_onHTTPClientGetCall_failsOnRequestError() {
    let url = URL(string: "http://any-url.com")!
    let error = NSError(domain: "any error", code: 1)
    let urlProtocol = URLProtocolStub()
    urlProtocol.stub(url: url, data: nil, response: nil, error: error)

    let sut = URLSessionHTTPClient()

    let exp = expectation(description: "Wait for completion")

    sut.get(from: url) { result in
        switch result {
        case let .failure(receivedError as NSError):
            XCTAssertEqual(receivedError, error)
        default:
            XCTFail("Expected failure with error \(error), got \(result) instead")
        }

        exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
}
```

In the code above we see our first test case. In the preparation part of it, we will create a URL, a specific *Error*, and an instance of our *URLProtocolStub*, where we will add the corresponding stub for that request with an error (and its other elements as nil).
We will then create an instance of the client and make an asynchronous call (with [*expectation*](https://developer.apple.com/documentation/xctest/xctestcase/1500899-expectation/ "expectation")).

Finally, we validate that the error received is the same as the one sent, through an *XCTAssertEqual(,)*, in the case of .*failure()*. In any other case, it is an unexpected result error.

If you're testing this in the IDE it's likely that nothing is compiling. This happens because we left the implementation of our Stub in the middle. We add that *URLProtocolStub* will be a subclass of *URLProtocol*, but we do not implement its requirements, which are mainly two.
On the one hand, we must implement four methods of *URLProtocol*:


```swift
class func canInit(with:URLRequest) -> Bool
class func canonicalRequest(for:URLRequest)
func startLoading()
func stopLoading()
```

On the other hand, we must register our protocol, using the methods:

```swift
URLProtocol.registerClass(AnyClass)
URLProtocol.unregisterClass(AnyClass)
```

Don't worry, we'll look at both requirements in detail below.

### Meeting the Requirements: Overriding the URLProtocol methods

Let's go through each of the methods that we need to override to meet the *URLProtocol* requirements. The first one will be *canInit(with: URLRequest) -> Bool*. If we return true in this method, it means that we can process this request, and it will be our responsibility to complete the request with success or failure. We will be able to know if the urlRequest contains the necessary parts to do it.

How can we know if we can process this request?

```swift
override class func canInit(with request: URLRequest) -> Bool {
       guard let url = request.url else { return false }
       
       return stubs[url] != nil
}
```

Basically, as we are storing in a dictionary the information of that request (our Stub element) indexed through the corresponding URL, what will tell us whether or not it can process this request will be determined by whether or not we have the stub stored in the dictionary.

But, if we add that method in XCode we will have an error of the type:

```swift
Instance member 'stubs' cannot be used on type 'URLSessionHTTPClientTest.URLProtocolStub'
```

This is because *canInit* is called as a class method because we don't have an instance yet. The URL Loading System will instantiate the *URLProtocolStub* only if the request can be processed. Since we don't have an instance there are some modifications we need to make.

First, our stubs dictionary should be defined as static:


```swift
private static var stubs = [URL: Stub]()
```

So should the "stub" method:

```swift
static func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) { ... }
```

Finally, in our test case, we will have to change the instantiation of the Stub, which would be like this, without creating any instance:

```swift
URLProtocolStub.stub(url: url, data: nil, response: nil, error: error)
```

Moving on, the next method we need to implement is *canonicalRequest(for request: URLRequest) -> URLRequest*. This method is used to return a canonical version of the request, as described in the [Apple documentation](https://developer.apple.com/documentation/foundation/urlprotocol/1408650-canonicalrequest "Apple documentation"). It's usually enough to return the same request, since we shouldn't make any changes to it, but maybe if you wanted to add a header, or change the URL scheme (for example), it would be a good place to do it. In our case it will be simply:

```swift
override class func canonicalRequest(for request: URLRequest) -> URLRequest { 
     return request
}
```

Then we have to override the *startLoading()* and *stopLoading()* methods, which are instance methods. This means that they are executed once it is accepted that it is going to process the request, and the necessary instance will be generated.

We start with *startLoading()*. Here when this method is called, the *URLProtocolStub* implementation should start loading the request:



```swift
override func startLoading() {
    guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }
    
    if let data = stub.data {
        client?.urlProtocol(self, didLoad: data)
    }
    
    if let response = stub.response {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    if let error = stub.error {
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    client?.urlProtocolDidFinishLoading(self)
}
```

Here, we get the url of the request (where request is an instance variable) and our stub for that url. With the guard let we make sure we have them, and if not, we finish the execution.
With the following if statement, if we get an error, we need to tell the URL Loading System that an error occurred, and we do this with another property of the URLProtocol instance, which is the client of type URLProtocolClient. This is an object that the protocol uses to communicate with the URL Loading System. This client has many methods and one of them tells the system that it failed with an error, via *urlProtocol(URLProtocol, didFailWithError: Error)*.

We can check in our stub the existence of data, we can tell the client to load "data", through *urlProtocol(URLProtocol, didLoad: Data)*.

Similarly, we check for the existence of a "response" , which we will do through *urlProtocol(URLProtocol, didReceive: URLResponse, cacheStoragePolicy: URLCache.StoragePolicy)*. In this case, we also send the Cache policy, which since we did not deal with it in this post, we will simply send it as .notAllowed.
Finally, once we finish we must tell the client that we finished the process, with *urlProtocolDidFinishLoading(URLProtocol)*.

The last method we need to implement is stopLoading(), where the stop loading of a request is processed. This could be used to handle a response to a cancellation, for example. In this case, we won't add an implementation, so it will look like this:

```swift
override func stopLoading() { }
```
It is important to implement it at least empty, otherwise, we will have a crash at runtime.
So, we complete the implementation of our stub. It should be like this:

```swift
private class URLProtocolStub: URLProtocol {
    private static var stubs = [URL: Stub]()

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    static func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) {
        stubs[url] = Stub(data: data, response: response, error: error)
    }

    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stubs = [:]
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }

        return URLProtocolStub.stubs[url] != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }

        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
```

### Meeting the requirements: Registering the protocol


URLProtocol subclasses are not known to the URL Loading System just because they exist. It is necessary that we register them before a request is made, and thus it will be visible to the system, searching for the different existing protocols and trying to process the request with each one of them. To do this, it is necessary to call the registerClass(AnyClass) class method that registers the protocol. Similarly, we can unsubscribe our URLProtocolStub with the unregisterClass(AnyClass) method.
By adding these two lines at the start and end of the test case, we would make it clear to the URL Loading System that we want it to use our Stub. Our test case would look like this:

```swift
func test_onHTTPClientGetCall_failsOnRequestError() {
    URLProtocol.registerClass(URLProtocolStub.self)
    let url = URL(string: "http://any-url.com")!
    let error = NSError(domain: "any error", code: 1)
    URLProtocolStub.stub(url: url, data: nil, response: nil, error: error)

    let sut = URLSessionHTTPClient()

    let exp = expectation(description: "Wait for completion")

    sut.get(from: url) { result in
        switch result {
        case let .failure(receivedError as NSError):
            XCTAssertEqual(receivedError, error)
        default:
            XCTFail("Expected failure with error \(error), got \(result) instead")
        }

        exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
    URLProtocol.unregisterClass(URLProtocolStub.self)
}
```

If we run the test case, it should pass without problems. Yay!

Although we could also add other test cases where we test other ways, as is the case with .success(), it is a good starting point to get into the use of URLProtocol.

By performing tests in this way, it allows us to avoid assumptions about behaviors that we are mocking in the tests, that may be unpredictable in production, or even that may change in the future, modifying the nature of what we are evaluating. Also, we avoid adding productive code just because we need it for testing, which is usually not a good sign.


#### References

- [Apple Documentation: URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol/ )
- [Apple Documentation: URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Apple Documentation: URLSessionDataTask](https://developer.apple.com/documentation/foundation/urlsessiondatatask)
- [Apple Documentation: URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
- [Testing Tips & Tricks (WWDC 2018)](https://developer.apple.com/videos/play/wwdc2018/417 )
