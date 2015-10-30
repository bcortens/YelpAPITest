//
//  YelpConnectionController.swift
//  YelpSampleAPI
//
//  Created by Benjamin Cortens on 2015-10-29.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import BDBOAuth1Manager

class YelpAPIConnection: BDBOAuth1RequestOperationManager
{
	//	Setup some constants
	let initialUrlString = "http://api.yelp.com/v2/"
	let initialUrl = NSURL(string:"http://api.yelp.com/v2/")
	
	let myYelpConsumerKey = "Kou6BMQSBBFH6HCj5cCnyg"
	let myYelpConsumerSecret = "ueh041N1Wk_EGdXe-06Q3YnY9Ho"
	let myYelpAccessToken = "Wfv4bciRsqi5Y66GJn8bvrKKpI7iDx2U"
	let myYelpAccessTokenSecret = "TtOgbyI8zqgxOXPPROdMOkGUsA4"
	
	required init(coder aDecoder: NSCoder)
	{
		//	If it is going to fail it should fail
		super.init(coder: aDecoder)!
	}
	
	init()
	{		
		super.init(baseURL: self.initialUrl, consumerKey: self.myYelpConsumerKey, consumerSecret: self.myYelpConsumerSecret)
		
		let bdbToken = BDBOAuth1Credential(token: self.myYelpAccessToken, secret: self.myYelpAccessTokenSecret, expiration: nil)
		
		self.requestSerializer.saveAccessToken(bdbToken)
	}
	
	//	MARK: Search Request
	
	//	Search the yelp system using the BDBOAUTH1Manager which actually uses AFNetworking under the hood
	//	The BDBOAuth Manager is used to authenticate and attach OAUTH1 headers
	//	The success paramter expects an operation object and a response object tuple. The operation object tells the underlying 
	//	program what type of operation to perform and the response object is the returned json string 
	//	The failure parameter uses the same response operation as the success operation but will also expect an error object as well
	//	The Method returns an AFHHTPRequestOperation
	func searchYelpWithString(searchString: String, parameters: Dictionary<String, String>? = nil, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation!
	{
		//	Only show 15 results - easiest for the sample application
		let limit: Int = 15
		//	Hard code in the location (makes it easier than specifying it somewhere else)
		let location: String = "Guelph"
		//	Create the parameters to submit to the YELP API
		let curParameters: NSMutableDictionary = [
			"location":location,
			"limit":limit,
			"term":searchString
		]
		
		//	Performs a GET operation using AFNetworking
		//	AFNetworking tries to use the query (search), BDBOAuthManager attaches an oauth header and the parameters are submitted
		//	If the result is returned AFNetworking parses the JSON into an NSDictionary and returns that to the calling success block (see SearchViewController.swift to view success block - in searchBarSearchButtonClicked)
		//	If it fails at any point it returns to the failure block (see SearchViewController.swift to view failure block - in searchBarSearchButtonClicked)
		return self.GET("search", parameters: curParameters , success: success, failure: failure)
	}
	
	
	
//	func postYelpReview(reviewString: String,parameters: Dictionary<String, String>? = nil, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation!
//	{
		
//	}

	
	
	//	MARK: Search Response Parsing
	
	//	Take in the response in the form of NSData object
	//	This object will then be parsed as a JSON object and the results converted into a business object
	func parseResponse(response: AnyObject) -> [Business]!
	{
		//	DEBUG:
		//	Print the response as it is recieved without any modificaiton or formatting
//		print(response)
		var businessesArray = [Business]()
		if response.isKindOfClass(NSDictionary)
		{
			let businesses = response["businesses"] as! NSArray
			
			//	Each business in the Array should be a dictionary
			//	The businesses are interated over and new Business objects are created, collected in the array
			for business in businesses
			{
				let name = business[Business.PropertyKey.nameKey] as! String
				
				//	What is the business name being examined?
				print ("Name \(name)")
				//	DEBUG:
				//	Print out the dictionary for the current business to see what it looks like
				//	print(business)
				let phoneNumber = business[Business.PropertyKey.phoneKey] as? String
				let location = business[Business.PropertyKey.locationKey] as! NSDictionary
				
				let addressArray = location[Business.PropertyKey.locationAddressKey] as? [String]
				let city = location[Business.PropertyKey.locationCityKey] as? String
				let provinceOrState = location[Business.PropertyKey.locationStateProvinceKey] as? String
				let country = location[Business.PropertyKey.locationCountryKey] as? String
				
				let categories = business[Business.PropertyKey.categoriesKey] as? Array<Array<String>>
				let imageUrlString = business[Business.PropertyKey.imageURLKey] as? String
				
				var imageView: UIImage?
				if imageUrlString != nil
				{
					let imgURL = NSURL(string: imageUrlString!)
					let imgData = NSData(contentsOfURL: imgURL!)
					imageView = UIImage(data: imgData!)
				}
				
				//	DEBUG:
				//	Print categories to see where the business fits
//				print ("Categories:")
//				print(categories)
				var categoryArray = [String]()
				if categories != nil
				{
					for category in categories!
					{
						//					print(category[0])
						categoryArray.append(category[0])
					}
				}
				
				let rating = business[Business.PropertyKey.ratingKey] as! Float
				let reviewCount = business[Business.PropertyKey.reviewsCountKey] as! Int
				
				let newBusiness = Business(name: name, phoneNumber: phoneNumber, categories:  categoryArray, image: imageView, address: addressArray, city: city, stateProvince: provinceOrState, country: country, rating: rating, reviewsCount: reviewCount)
				businessesArray.append(newBusiness!)
			}
		}
		else if response.isKindOfClass(NSArray)
		{
			print("Error: Response to search request should be dictionary")
		}
		else
		{
			print("Response returned no results")
		}
		
		return businessesArray
		
	}
}

