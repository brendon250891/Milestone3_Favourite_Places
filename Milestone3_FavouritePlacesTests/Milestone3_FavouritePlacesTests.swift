//
//  Milestone3_FavouritePlacesTests.swift
//  Milestone3_FavouritePlacesTests
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import XCTest
@testable import Milestone3_FavouritePlaces

class Milestone3_FavouritePlacesTests: XCTestCase {
    let categoryName = "Sydney"
    let placeName = "Sydney Opera House"
    let address = "Bennelong Point, Sydney, NSW"
    let latitude = -33.8568
    let longitude = 151.2153
    let date = "2019-05-14"
    let sunriseAndSunset = SunriseAndSunsetResponse(results: SunriseAndSunset(sunrise: "6:00:00 AM", sunset: "6:00:00 PM", dayLength: "12:00:00", midday: "12:00:00 PM", twilight: "7:00:00 PM"), status: "OK")
    let weather = Weather(weather: [WeatherDescription(description: "sky is clear")], main: WeatherTemperature(minTemperature: 15.0, maxTemperature: 20.0))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDefaultCategoryConstructor() {
        let category = Category()
        
        XCTAssertTrue(category.getCategoryName() == "" && category.getPlaceCount() == 0)
    }
    
    func testCategoryConstructorGivenName() {
        let category = Category(categoryName)
        
        XCTAssertTrue(category.getCategoryName() == categoryName && category.getPlaceCount() == 0)
    }
    
    func testGetCategoryName() {
        let category = Category(categoryName)
        
        XCTAssertTrue(category.getCategoryName() == categoryName)
    }
    
    func testSetCategoryName() {
        let category = Category()
        category.setCategoryName(categoryName)
        
        XCTAssertTrue(category.getCategoryName() == categoryName)
    }
    
    func testGetPlaceCount() {
        let category = Category()
        
        XCTAssertTrue(category.getPlaceCount() == 0)
    }
    
    func testIsCategoryCollapsed() {
        let category = Category()
        
        XCTAssertTrue(category.isCategoryCollapsed() == false)
    }
    
    func testAddPlace() {
        let category = Category()
        let place = Place()
        category.addPlace()
        
        XCTAssertEqual(category.getPlace(category.getPlaceCount() - 1), place)
    }
    
    func testGetPlace() {
        let category = Category()
        category.addPlace()
        let place = category.getPlace(category.getPlaceCount() - 1)
        
        XCTAssertNotNil(place)
    }
    
    func testRemovePlace() {
        let category = Category()
        category.addPlace()
        category.removePlace(category.getPlaceCount() - 1)
        
        XCTAssertEqual(category.getPlaceCount(), 0)
    }
    
    func testInsertPlace() {
        let category = Category()
        category.addPlace()
        let place = Place(placeName, address, latitude, longitude)
        category.insertPlace(place, 0)
        
        XCTAssertEqual(category.getPlace(0), place)
    }
    
    // MARK: - Place tests
    
    func testDefaultPlaceConstructor() {
        let place = Place()
        
        XCTAssertTrue(place.getName() == "" && place.getAddress() == "" && place.getLatitude() == 0.0 && place.getLongitude()
         == 0.0)
    }
    
    func testPlaceConstructorWithParameters() {
        let place = Place(placeName, address, latitude, longitude)
        
        XCTAssertTrue(place.getName() == placeName && place.getAddress() == address && place.getLatitude() == latitude && place.getLongitude() == longitude)
    }
    
    func testGetPlaceName() {
        let place = Place(placeName, address, latitude, longitude)
        
        XCTAssertEqual(place.getName(), placeName)
    }
    
    func testSetPlaceName() {
        let place = Place()
        place.setName(placeName)
        
        XCTAssertEqual(place.getName(), placeName)
    }
    
    func testGetAddress() {
        let place = Place(placeName, address, latitude, longitude)
        
        XCTAssertEqual(place.getAddress(), address)
    }
    
    func testSetAddress() {
        let place = Place()
        place.setAddress(address)
        
        XCTAssertEqual(place.getAddress(), address)
    }
    
    func testGetLatitude() {
        let place = Place(placeName, address, latitude, longitude)
        
        XCTAssertEqual(place.getLatitude(), latitude)
    }
    
    func testSetLatitude() {
        let place = Place()
        place.setLatitude(latitude)
        
        XCTAssertEqual(place.getLatitude(), latitude)
    }
    
    func testGetLongitude() {
        let place = Place(placeName, address, latitude, longitude)
        
        XCTAssertEqual(place.getLongitude(), longitude)
    }
    
    func testSetLongitude() {
        let place = Place()
        place.setLongitude(longitude)
        
        XCTAssertEqual(place.getLongitude(), longitude)
    }
    
    func testAddSunriseAndSunsetTimes() {
        let place = Place(placeName, address, latitude, longitude)
        place.addSunriseAndSunsetTimes(date, sunriseAndSunset: sunriseAndSunset.results)
        
        XCTAssertNotNil(place.getSunriseAndSunsetTimes(date))
    }
    
    func testGetSunriseAndSunsetTimes() {
        let place = Place(placeName, address, latitude, longitude)
        place.addSunriseAndSunsetTimes(date, sunriseAndSunset: sunriseAndSunset.results)
        
        guard let sunriseAndSunsetTimes = place.getSunriseAndSunsetTimes(date) else { return }
        
        XCTAssertEqual(sunriseAndSunsetTimes, sunriseAndSunset.results)
    }
    
    func testAddWeatherInformation() {
        let place = Place(placeName, address, latitude, longitude)
        place.addWeather(date, weather: weather)
        
        XCTAssertNotNil(place.getWeather(date))
    }
    
    func testGetWeatherInformation() {
        let place = Place(placeName, address, latitude, longitude)
        place.addWeather(date, weather: weather)
        guard let retrievedWeather = place.getWeather(date) else { return }
        XCTAssertEqual(retrievedWeather, weather)
    }
    
    // MARK: - CategoryDB tests
    
    func testAddCategory() {
        let categories = CategoryDB()
        categories.addCategory()
        XCTAssertEqual(categories.getCategory(categories.getCategoryCount() - 1), Category())
    }
    
    func testAddCategoryWithName() {
        let categories = CategoryDB()
        categories.addCategory(categoryName)
        let lastAdded = categories.getCategory(categories.getCategoryCount() - 1)
        
        XCTAssertEqual(lastAdded.getCategoryName(), categoryName)
    }
    
    func testRemoveCategory() {
        let categories = CategoryDB()
        categories.addCategory(categoryName)
        categories.addCategory()
        
        categories.removeCategory(categories.getCategoryCount() - 1)
        XCTAssertEqual(categories.getCategory(categories.getCategoryCount() - 1).getCategoryName(), categoryName)
    }
    
    func testRemoveCategoryGivenCategory() {
        let categories = CategoryDB()
        categories.addCategory()
        let category = categories.getCategory(categories.getCategoryCount() - 1)
        let count = categories.getCategoryCount()
        let removed = categories.removeCategory(category)
        
        XCTAssertEqual(count - 1, removed)
    }
    
    func testFindEmptyPlace() {
        let categories = CategoryDB()
        categories.addCategory()
        let category = categories.getCategory(categories.getCategoryCount() - 1)
        category.addPlace()
        
        let emptyPlaceCategoryIndex = categories.findEmptyPlace()
        let emptyCategory = categories.getCategory(emptyPlaceCategoryIndex ?? 0)
        
        XCTAssertEqual(emptyCategory.getPlace(emptyCategory.getPlaceCount() - 1), Place())
    }
}
