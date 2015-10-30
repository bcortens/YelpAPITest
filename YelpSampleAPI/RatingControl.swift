//
//  RatingControl.swift
//  YelpSampleAPI
//
//  Created by Benjamin Cortens on 2015-10-30.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

class RatingControl: UIView
{
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	// MARK: Properties
	var rating = 0.0 {
		didSet
		{
			//	Everytime the rating changes it needs to be updated
			//	Not used in the business yelp sample application, but used in other applications that use this control
			setNeedsLayout()
		}
	}
	
	//	Use buttons so that ratings are possible (Note: Not used in the yelp sample application but used in other apps)
	var ratingButtons = [UIButton]()
	
	var spacing = 5
	var stars = 5
	
	
	// MARK: Initialization
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		
		//	Load the images to use for the button control
		let emptyStar = UIImage(named: "emptyStar")
		let filledStar = UIImage(named: "filledStar")
		
		for _ in 0..<self.stars
		{
			//	Create and add a simple button to the rating control
			let ratingButton = UIButton()
			
			ratingButton.setImage(emptyStar, forState: .Normal)
			ratingButton.setImage(filledStar, forState: .Selected)
			ratingButton.setImage(filledStar, forState: [.Highlighted, .Selected])
			
			ratingButton.adjustsImageWhenHighlighted = false
			
			ratingButton.addTarget(self, action: "ratingButtonPressed:", forControlEvents: .TouchUpInside)
			self.ratingButtons += [ratingButton]
			self.addSubview(ratingButton)
		}
		
	}
	
	//	By overriding this method the rating control is able to build the stars at the appropriate size without interfering with the autolayout
	override func intrinsicContentSize() -> CGSize
	{
		let buttonSize = Int(frame.size.height)
		let width = (buttonSize + self.spacing) * self.stars
		return CGSize(width: width, height: buttonSize)
	}
	
	//	Place the stars in the view
	override func layoutSubviews()
	{
		let buttonSize = Int(self.frame.size.height)
		var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		
		//	Offset the x position of each button
		//	Ensures that the buttons are spaced nicely
		for(index, button) in self.ratingButtons.enumerate()
		{
			buttonFrame.origin.x = CGFloat(index * (buttonSize + self.spacing))
			button.frame = buttonFrame
		}
		
		self.updateButtonSelectionStates()
	}
	
	
	//	NOTE:
	//	Half star support was added to support the Yelp app 
	//	This meant writing the interior checks to determine if the state should be set to show the half star
	//	This has not yet been tested to allow user ratings
	func updateButtonSelectionStates()
	{
		let halfStar = self.rating - Double(Int(self.rating))
		var didSetHalfStar = false
		let halfStarImage = UIImage(named: "halfStar")
		for(index, button) in self.ratingButtons.enumerate()
		{
			
			//	The right side of the = first performs an evaluation and then assigns the truth value to the buttons selected state property
			button.selected = (index < Int(self.rating))
			if halfStar > 0.0
			{
				
				let checkStar = Int(self.rating) + 1
				//				print("Should print half star: \(halfStar) curIndex: \(index) checkStar: \(checkStar) rating: \(self.rating) intRating \(Int(self.rating)) didsetHalfStar: \(didSetHalfStar)")
				if index < checkStar && index >= Int(self.rating) && !didSetHalfStar
				{
					//					print("Setting half star")
					didSetHalfStar = true
					button.setImage(halfStarImage,forState: .Selected)
					button.selected = true
				}
			}
		}
		
	}
	
	
	
	
	// MARK: Button actions
	
	func ratingButtonPressed(button: UIButton)
	{
//		self.rating = ratingButtons.indexOf(button)! + 1
		self.updateButtonSelectionStates()
		//		print("Button pressed 👍");
	}
	
	
	
}
