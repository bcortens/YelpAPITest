//
//  Business.swift
//  YelpSampleAPI
//
//  Created by Benjamin Cortens on 2015-10-30.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

//
//	Container model class for the results of the search query
//
class Business: NSObject
{
	//	MARK: Types
	struct PropertyKey
	{
		static let nameKey = "name"
		static let phoneKey = "display_phone"
		static let imageURLKey = "image_url"
		static let categoriesKey = "categories"
		
		static let locationKey = "location"
		//	This key is within the location object
		static let locationAddressKey = "display_address"
		static let locationCityKey = "city"
		static let locationStateProvinceKey = "state_code"
		static let locationCountryKey = "country_code"
		
		static let ratingKey = "rating"
		static let reviewsCountKey = "review_count"
	}
	
	//	MARK: Properties
	var name: String
	var phoneNumber: String?
	var displayImage: UIImage?
	var categories: [String]?
	var address: [String]?
	var city: String?
	var stateProvince: String?
	var country: String?
	var rating: Float
	var reviewsCount: Int
	
	
	//	MARK: Initialization
	//	MARK: Initialization
	init?(name: String, phoneNumber: String?, categories: [String]?, image: UIImage?, address: [String]?, city: String?, stateProvince: String?, country: String?, rating: Float, reviewsCount: Int)
	{
		self.name = name
		self.phoneNumber = phoneNumber
		self.displayImage = image
		self.categories = categories
		self.address = address
		self.rating = rating
		self.reviewsCount = reviewsCount
		self.city = city
		self.stateProvince = stateProvince
		self.country = country
		
		
		super.init()
		
		//	If the values that are expected are empty return nil
		if(name .isEmpty  || rating < 0.0 || reviewsCount < 0)
		{
			return nil
		}
	}
}
