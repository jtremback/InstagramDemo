## Rotten Tomatoes

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

I spent longer on it than I could have, because I wanted to find the best patterns to use in the future. Using the libraries `SwiftyJSON` and `AlamoFire` helped keep the code pretty elegant. Hopefully these will help me go faster in the future. I also needed a bit of time to adjust to the strict nature of Swift. Another big time suck was trying to get a scroll view for the detail view. I was not able to accomplish this task in IB, and I don't see the point of using IB for only some parts of an app. I have been forced to conclude that IB is unfit for its intended purpose. Next week I will be building everything programatically without Storyboards. For now I used a design that IB was able to handle, animating a constraint on a view when tapped instead of scrolling smoothly.

I also ventured into running JS in the app. I work on a lot of data processing and networking code in JS, so it's nice that it can be a portable element to include in an iOS app. For this project, I composed a color in the LAB space out of the critic's score and the viewer's score. I then used a JS library to convert back into RGB and make a UIColor. Everything worked well. You can see the results of this in the coloring of the titles on the list page. The color depends on the relationship between viewer and critic scores of the movie. In future projects, I will be investigating how to run levelDb in a JS context.

Time spent: 15hrs

### Features

#### Required

- [x] User can view a list of movies. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees error message when there is a network error: http://cl.ly/image/1l1L3M460c3C
- [x] User can pull to refresh the movie list.

#### Optional

- [ ] All images fade in.
- [ ] For the larger poster, load the low-res first and switch to high-res when complete.
- [x] All images should be cached in memory and disk: AppDelegate has an instance of `NSURLCache` and `NSURLRequest` makes a request with `NSURLRequestReturnCacheDataElseLoad` cache policy. I tested it by turning off wifi and restarting the app.
- [x] Customize the highlight and selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Add a tab bar for Box Office and DVD.
- [ ] Add a search bar: pretty simple implementation of searching against the existing table view data.

### Walkthrough
![Video Walkthrough](https://raw.githubusercontent.com/jtremback/RottenTomatoes/master/ok2.gif)

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [AlamoFire](https://github.com/Alamofire/Alamofire)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [ColorConvert](https://github.com/harthur/color-convert)
