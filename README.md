PhotoPicker  

## Demo
![demo](http://giphy.com/gifs/l3q30kL1PjN3wZadW | 320x670)
## Use API 
Flickr API (https://www.flickr.com/services/api/)
## Usage
*Step1
```
pod install
```
*Step2  
Please register Flickr, and get Token.  

*Step3  
Set token to "ApiInfomation.swift".  
```
struct ApiInfomation {
    static let baseUrl: String = "https://api.flickr.com"

    static let path: String = "/services/rest"
    
    static let apiKey = "123456789"
    static let apiSecretKey = "123456789"   
}
```

