//
//  GameSceneViewContoller.m
//  Memory Game
//
//  Created by msweatt on 5/30/14.
//  Copyright (c) 2014 msweatt. All rights reserved.
//

#import "GameSceneViewContoller.h"

@interface GameSceneViewContoller ()

@property UIImage *blankTileImage; //image property for blank tile
@property UIImage *backTileImage; //image property for tile face down

//Arrays for showing tiles and shuffling tiles
@property NSMutableArray *tiles; //Array for use when showing tiles
@property NSMutableArray *shuffledTiles; //Array for use to number and line up tiles

//Counters for correct matches and incrementing guesses
@property NSInteger matchCounter;  //Integer to increment for correct matches
@property NSInteger guessCounter; //Integer to increment for number of guesses

//Properties for matching tiles
@property NSInteger tileFlipped; //ID for first flipped tile, when not set will be set to -1
@property UIButton *tile1;
@property UIButton *tile2;

//Private Methods & arguments to be used within Controller
-(void)shuffleTiles;
-(void)resetTiles;
-(void) winner;

@end

@implementation GameSceneViewContoller

static bool isDisabled = false; //Boolean for when two tiles are turned
static bool isMatch = false; //Boolean for when tiles match

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backTileImage = [UIImage imageNamed:@"back.png"];  //load back tile image png file
    self.blankTileImage = [UIImage imageNamed:@"blank.png"];  //load blank tile image png file
    
    self.tileFlipped = -1;  //set up integer for tileFlipped logic
    //Setting Counters for matches and guesses
    self.matchCounter = 0;
    self.guessCounter = 0;
    
    self.gameScoreLabel.text = [NSString stringWithFormat:@"Matches: %d Guesses: %d" , self.matchCounter, self.guessCounter];
    
    //Initalize tiles array with tile png files
    self.tiles = [[NSMutableArray alloc]initWithObjects:
                  [UIImage imageNamed:@"icons01.png"],
                  [UIImage imageNamed:@"icons01.png"],
                  [UIImage imageNamed:@"icons02.png"],
                  [UIImage imageNamed:@"icons02.png"],
                  [UIImage imageNamed:@"icons03.png"],
                  [UIImage imageNamed:@"icons03.png"],
                  [UIImage imageNamed:@"icons04.png"],
                  [UIImage imageNamed:@"icons04.png"],
                  [UIImage imageNamed:@"icons05.png"],
                  [UIImage imageNamed:@"icons05.png"],
                  [UIImage imageNamed:@"icons06.png"],
                  [UIImage imageNamed:@"icons06.png"],
                  [UIImage imageNamed:@"icons07.png"],
                  [UIImage imageNamed:@"icons07.png"],
                  [UIImage imageNamed:@"icons08.png"],
                  [UIImage imageNamed:@"icons08.png"],
                  [UIImage imageNamed:@"icons09.png"],
                  [UIImage imageNamed:@"icons09.png"],
                  [UIImage imageNamed:@"icons10.png"],
                  [UIImage imageNamed:@"icons10.png"],
                  [UIImage imageNamed:@"icons11.png"],
                  [UIImage imageNamed:@"icons11.png"],
                  [UIImage imageNamed:@"icons12.png"],
                  [UIImage imageNamed:@"icons12.png"],
                  [UIImage imageNamed:@"icons13.png"],
                  [UIImage imageNamed:@"icons13.png"],
                  [UIImage imageNamed:@"icons14.png"],
                  [UIImage imageNamed:@"icons14.png"],
                  [UIImage imageNamed:@"icons15.png"],
                  [UIImage imageNamed:@"icons15.png"],
                  nil];  //nil sent to terminate array

    //Method to shuffle tiles
    [self shuffleTiles];
    
    
}

-(void)shuffleTiles
{
    int tileCount = [self.tiles count]; //counter for tiles array for num. of tiles to shuffle -use this method in case tile array increments or decrements
    
    //for loop to populate shuffledaTiles array
    for(int tileID=0; tileID<(tileCount/2); tileID++) //this for loop fills array with numbers (0,0,1,1,2,2...14,14)
    {
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
    }
    
    for (NSUInteger i=0; i<tileCount; ++i) //This for loop use random num generator to take array and shuffle
    {
        NSInteger nElements = tileCount - i;
        NSInteger n = (arc4random()% nElements)+i;
        [self.shuffledTiles exchangeObjectAtIndex:i withObjectAtIndex:n];
        [self.tiles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tileClicked:(id)sender
{
    if(isDisabled == true)
        return;
    
    int senderID = [sender tag];
    
    if(self.tileFlipped >=0 && senderID !=self.tileFlipped){
        self.tile2 = sender;
        
        UIImage *lastImage = [self.tiles objectAtIndex: self.tileFlipped];
        UIImage *tileImage = [self.tiles objectAtIndex: senderID];
        
        [sender setImage: tileImage forState:UIControlStateNormal];
        self.guessCounter++;
        
        if(tileImage == lastImage)
        {
            [self.tile1 setEnabled:false];
            [self.tile2 setEnabled:false];
            self.matchCounter++;
            isMatch = true;
        }
            isDisabled=true;
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                             selector:@selector(resetTiles)
                                             userInfo:nil
                                             repeats: NO];
            self.tileFlipped = -1;
        }
        else{
            self.tileFlipped = senderID;
            self.tile1 = sender;
            UIImage *tileImage = [self.tiles objectAtIndex: senderID];
            [sender setImage: tileImage forState:UIControlStateNormal];
        }
        
        self.gameScoreLabel.text = [NSString stringWithFormat:@"Matches: %d Guesses:%d", self.matchCounter, self.guessCounter];  //update score match or not
    }
    
//    NSLog(@"Our ID is: %d\n", senderID); //debug line used for making sure array asigned tiles correctly


-(void) resetTiles  //method called once timer = 0
{
    if(isMatch)
    {
        [self.tile1 setImage: self.blankTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.blankTileImage forState:UIControlStateNormal];
        
    }
    else
    {
        [self.tile1 setImage: self.backTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.backTileImage forState:UIControlStateNormal];
    }
    isDisabled = false;
    isMatch = false;
    
    if(self.matchCounter == (self.tiles.count/2))
        [self winner];
}

-(void) winner

{
    self.gameScoreLabel.text = [NSString stringWithFormat:@"You won with %d Guesses", self.guessCounter];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
