//
//  ViewController.swift
//  YelpSampleAPI
//
//  Created by Benjamin Cortens on 2015-10-29.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

//
//	This class is responsible for not only handling the user input into the text box but also managing the table view that is holding the results.
//
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate
{

	//	MARK: Properties
	var yelpConnection: YelpAPIConnection!
	var searchResults: [Business] = []
	
	//	Interface builder properties
	@IBOutlet weak var resultsTableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	
	
	
	//	NOTE: 
	//	Using AFNetworking means that the response will be serialized into an NSDictionary or NSArray by the framework.
	//	This convenience framework means that the try catch JSON serialization is done inside AFNetworking. 
	//	The errors are returned as failures 
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		//	Setup the API Connection which is responsible for managing our connection to the YELP API
		//	This initial step is all that is needed to add the oauth header
		//	Header is managed by the BDBOAuthManager framework
		self.yelpConnection = YelpAPIConnection()
		
		self.resultsTableView.delegate = self;
		self.resultsTableView.dataSource = self;
		
		self.searchBar.delegate = self;
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Table view data source
	
	//	Configure the cells
	//	Setup the cells based on the contents of the search results array
	//	This method is called automatically and uses the prototype cell built in the storyboard to generate a new BuisnessTableViewCell
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		//	Get the cell based on its identifier (specified in the storyboard) and downcast it to the appropriate type
		let cellIdentifier = "SearchResultsCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BusinessTableViewCell
		
		//	Use the row index to get the current business from the search results
		let business = self.searchResults[indexPath.row]
		
		
		//	Configure the cell based on the business
		cell.nameLabel.text = business.name
		
		//	Add the phone number to the business entry
		//	Need to check if its emtpy since YELP can return nil values
		var phoneNumberString = ""
		if(business.phoneNumber?.isEmpty) == false
		{
			phoneNumberString = business.phoneNumber!
		}
		cell.phoneNumber.text = phoneNumberString
		
		//	Add the address to the business entry
		//	Need to check if its emtpy since YELP can return nil values
		//	Checks each portion of the address independently to ensure it doesn't attempt to initialize with an empty value
		var addressString = ""
		if(business.city?.isEmpty) == false
		{
			addressString = addressString + business.city!
		}
		if(business.stateProvince?.isEmpty) == false
		{
			if addressString.isEmpty == false
			{
				addressString = addressString + ", "
			}
			addressString = addressString + business.stateProvince!
		}
		if(business.country?.isEmpty) == false
		{
			if addressString.isEmpty == false
			{
				addressString = addressString + ", "
			}
			addressString = addressString + business.country!
		}
		cell.address.text = addressString
		
		//	Add the rating to the business entry
		cell.ratingControl.rating = Double(business.rating)
		
		//	Add the categories to the business entry
		//	Need to check if its emtpy since YELP can return nil values
		var categoriesString = ""
		if(business.categories?.isEmpty) == false
		{
			for (index,category) in business.categories!.enumerate()
			{
				categoriesString.appendContentsOf(category)
				if index < (business.categories!.count - 1)
				{
					categoriesString.appendContentsOf(", ")
				}
			}
		}
		cell.categoriesLabel.text = categoriesString
		
		//	Add the display image to the cell
		//	Need to check if its emtpy since YELP can return nil values
		if business.displayImage != nil
		{
			cell.photoPreview?.image = business.displayImage
		}
		
		return cell;
	}
	
	
	//	Number of Rows in Section
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		//	DEBUGGING
		//	Print out the number of search results
//		print("Count of serach results \(self.searchResults.count")
		
		return self.searchResults.count
	}
	
	
	
	
	//	MARK: SearchBarDelegate
	
	//
	//	Search button clicked (or enter pressed if in the iOS simulator or using a hardware keyboard)
	//
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		searchBar.resignFirstResponder()
		if ((searchBar.text?.isEmpty) == false)
		{
			print("Search text \(searchBar.text)")
			//	The main search action
			//	Take the input string from the search field and use it
			//	to search the yelp database and return some results
			self.yelpConnection.searchYelpWithString(searchBar.text!,
				success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

					//	Success block
					//	Handle a successful returned response here
					
					//	DEBUG:
					//	Currently - print out the raw dictionary
			//		print(response)

					//	SearchResults returns an array of businesses
					self.searchResults = self.yelpConnection.parseResponse(response)
					//	Reload the data to display the search results
					self.resultsTableView.reloadData()
					
					//	End of success block
				},
				failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
					//	Failure block
					//
					print(error)
					//	End of failure block
			})
		}
	}
	
	
	//
	//	When the search bar is emptied it no longer should display any text
	//
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
	{
		if(searchBar.text?.isEmpty == true)
		{
			self.searchResults.removeAll()
			self.resultsTableView.reloadData()
		}
	}
	
	
}

