# CallSignNetworkingManager - Assignment Documentation

## Overview

CallSignNetworkingManager is a modular and extensible Objective-C networking library designed for a job interview assignment. It follows best practices in network abstraction, supports mocking for testing, and simplifies HTTP request handling.

---

## Project Structure

```
Pods/
├── Development Pods/
│   └── CallSignNetworkingManager/
│       ├── NetworkManager.h / .m
│       ├── NetworkRequest.h
│       ├── Error/
│       │   └── NSError+NetworkError.h / .m
│       ├── ImageLoader/
│       │   └── ImageDownloader.h / .m
│       └── Logger/
│           └── Logger.h / .m
└── Podspec
```

---

## Key Components

### 1. `NetworkManager`

A singleton class that manages all networking operations.

#### Features:

* Supports `GET`, `POST`, `PUT`, `DELETE` methods.
* Mocking mechanism via `sandboxMode` and `mockJSONResponse`.
* Adds headers and handles common errors like no internet, server failures.
* Uses `NSURLSession` under the hood.

### 2. `NetworkRequest`

A protocol that all request types conform to. It abstracts request properties like:

* `baseURL`
* `path`
* `parameters`
* `headers`
* `method`
* `mockJSONResponse`

### 3. `NSError+NetworkError`

Custom error handling categories that provide user-friendly and standardized error messages for:

* Invalid URLs
* Server errors
* JSON decoding failures
* Unknown issues

### 4. `Logger`

Logs JSON responses and errors to help with debugging.

### 5. `ImageDownloader`

An additional utility for downloading and caching images from the network (optional for this assignment).

---

## Sample Usage

```objc
MyRequest *request = [[MyRequest alloc] init];
request.mockJSONResponse = @"{\"status\": \"success\"}";

[[NetworkManager shared] sendRequest:request completion:^(NSDictionary *response, NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Success: %@", response);
    }
}];
```

---

## Testing Support

Mocking is supported via the `mockJSONResponse` property and `sandboxMode` flag. This allows for testable logic without network calls:

```objc
request.mockJSONResponse = @"{ \"message\": \"This is a mock response\" }";
NetworkManager.shared.sandboxMode = YES;
```

---

## Challenges & Solutions

* **Header not found issue:** Solved by correctly setting `podspec` to expose headers with `s.public_header_files = 'CallSignNetworkingManager/**/*.h'`
* **Xcode permission error:** Diagnosed as macOS sandbox issue and fixed by adjusting folder permissions and enabling Full Disk Access.
* **Testing dependency:** Used mockable design pattern to allow unit testing without real network dependencies.

---

## Conclusion

This module reflects strong understanding of iOS networking, clean architecture principles, and testability. It's well-structured, mock-friendly, and reusable in production-grade apps.

---

## Future Improvements

* Add support for multipart/form-data uploads.
* Retry logic for transient errors.
* Integrate a more modern API like Combine or NSURLSession+Swift for newer codebases.
