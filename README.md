# EasyNetworking

This is a simple wrapper around `URLSession` to make its usage more leightweight. All awesome features (for example thread-safety) are therefore included.

## Features

* Data and upload task handling, optional response parsing to `Decodable`-s.
* Returns `Combine` publishers, therefore your view model-s can subscribe to the results by using  `.sink`.
* It uses the default `URLSession.shared`, but you can pass your own session to it as well.

## What is not included

Custom features are not added to the library, but since you can pass your own `URLSession`,  delegate logic can be added on the client-side. Some examples: session delegate handling, caching, handling authentication challenges, certificate pinning.

## Integration

Select your main project. On the Swift packages tab, tap on the `+` icon to add a new dependency. Enter `git@github.com:tamasdancsi/ios-easy-networking.git`, hit next twice and you're ready to go.

## Usage
