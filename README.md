## CodePath Week 2: Yelp Search

This is a Yelp Search client written in Swift that uses the [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api). It uses various UIKit and MapKit components to display Yelp businesses in a list view and map view.

**Time spent**: Approximately 22 hours total

### Issues

* There are constraint warnings for my TableViewCells that I couldn't figure out how to remove. I reset all constraints two times and ended up with similar results each time even though I felt the constraints became more minimal and cleaner. There doesn't appear to be any issues with the layout visually.
* Since I was playing around with a lot of new APIs and iOS paradigms (AutoLayout, CoreLocation, MapKit, delegates, NotificationCenter, etc), I didn't put a lot of focus in error handling. I'm pretty sure this app will blow up if you are not connected to the Internet or if the Yelp API's responses were missing some details for a particular business.

### Walkthrough

![Walkthrough](Yelp.gif)

### Requirements

All of the requirements were completed.

  * [x] Search results page
    * [x] Table rows should be dynamic height according to the content height
    * [x] Custom cells should have the proper Auto Layout constraints
    * [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
    * [x] Optional: infinite scroll for restaurant results
    * [x] Optional: Implement map view of restaurant results
  * [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
    * [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
    * [x] The filters table should be organized into sections as in the mock.
    * [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch
    * [x] Radius filter should expand as in the real Yelp app
    * [x] Categories should show a subset of the full list with a "See All" row to expand.
    * [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
  * [x] Optional: Implement the restaurant detail page.

Some extra, noteworthy features that were implemented:

  * Uses CoreLocation to enable location-aware searches and show user's location in the map view.
  * Created an animated loading indicator using Yelp's logo with `UIImage.animatedImageName` 
  * I implemented many of the searching and browsing features in the map view as well. Moving the map will show a "Redo Search In This Area" button which will use the bounds of the map view to perform a Yelp search.

### Installation

Run the following in command-line:

```
pod install
open Yelp.xcworkspace
```

In XCode 6, run the app using the `iPhone 5S` or `iPhone 6` simulators.

### Resources

The following CocoaPods were used:

  * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
  * [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
  * [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)

I used a few icons from [NounProject](http://thenounproject.com/):

  * Search by Marcos Folio
  * Map by Simple Icons
  * Price Tag by hunotika
  * Arrow Down by Riley Shaw
  * tick by Maurizio Pedrazzo
  * Crosshair by Naomi Atkinson

I also used the Yelp logo for the app icon, splash screen, and loading indicator (which I found on Google Images).

### License

> The MIT License (MIT)
>
> Copyright © 2014 Jerry Su, http://jerrysu.me
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of
> this software and associated documentation files (the “Software”), to deal in
> the Software without restriction, including without limitation the rights to
> use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
> the Software, and to permit persons to whom the Software is furnished to do so,
> subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
> FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
> COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
> IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
