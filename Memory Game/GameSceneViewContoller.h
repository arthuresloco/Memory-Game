//
//  GameSceneViewContoller.h
//  Memory Game
//
//  Created by msweatt on 5/30/14.
//  Copyright (c) 2014 msweatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSceneViewContoller : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonviews;
@property (strong, nonatomic) IBOutlet UILabel *gameScoreLabel;

-(IBAction)tileClicked:(id)sender;

@end
