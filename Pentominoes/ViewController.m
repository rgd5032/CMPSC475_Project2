//
//  ViewController.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/8/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "ViewController.h"

#define kEdgePaddingForPlayingPieces 80
#define kPaddingBetweenPlayingPieces 30
#define kPlayingPieceRowHeight 140
#define kPaddingBetweenPiecesAndBoard 40
#define kBoardBlockDimension 30

@interface ViewController ()
- (IBAction)boardButtonClicked:(id)sender;
- (IBAction)solveButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *boardView;
@property (strong, nonatomic) NSArray *boardImages;
@property (strong, nonatomic) NSMutableDictionary *playingPieces;
@property (strong, nonatomic) NSArray *solutions;
@property NSInteger currentBoardNumber;
@property BOOL puzzleSolved;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _boardImages = [[NSArray alloc] initWithObjects:
                    [UIImage imageNamed:@"Board0.png"],
                    [UIImage imageNamed:@"Board1.png"],
                    [UIImage imageNamed:@"Board2.png"],
                    [UIImage imageNamed:@"Board3.png"],
                    [UIImage imageNamed:@"Board4.png"],
                    [UIImage imageNamed:@"Board5.png"],
                    nil];
    [self createPlayingPieces];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"Solutions" ofType:@"plist"];
    self.solutions = [NSArray arrayWithContentsOfFile:path];
    self.puzzleSolved = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.currentBoardNumber = 0;
    [self.boardView setImage: self.boardImages[self.currentBoardNumber]];
    [self placePlayingPieces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createPlayingPieces
{
    _playingPieces = [[NSMutableDictionary alloc] init];
    NSArray *playingPieceNames = @[@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    for (NSString *name in playingPieceNames)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tile%@", name]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        [self.playingPieces setObject:imageView forKey:name];
    }
}

-(void)placePlayingPieces
{   
    // Leave a padding at the beginning and end
    CGFloat rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
    CGFloat originX = kEdgePaddingForPlayingPieces;
    CGFloat originY = self.boardView.frame.origin.y + self.boardView.frame.size.height + kPaddingBetweenPiecesAndBoard;
    CGPoint currentOrigin = CGPointMake(originX, originY);
    
    for (id key in self.playingPieces){
        
        UIImageView *imageView = [self.playingPieces objectForKey:key];
        imageView.transform = CGAffineTransformIdentity;
        // If there isn't enough space at the end of the row, start a new row
        if (rowSpaceRemaining < imageView.frame.size.width + kEdgePaddingForPlayingPieces){
            rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
            currentOrigin.y += kPlayingPieceRowHeight;
            currentOrigin.x = kEdgePaddingForPlayingPieces;
        }
        
        imageView.frame = CGRectMake(currentOrigin.x, currentOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        rowSpaceRemaining -= imageView.frame.size.width + kPaddingBetweenPlayingPieces;
        currentOrigin.x = self.view.bounds.size.width - rowSpaceRemaining;
        [imageView convertPoint:imageView.frame.origin toView:self.view];
        [self.view addSubview:imageView];
    }
}

-(void) resetPlayingPieces
{
    if (self.puzzleSolved){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [self placePlayingPieces];
        [UIView commitAnimations];
        self.puzzleSolved = NO;
    }
}

- (IBAction)boardButtonClicked:(id)sender {
    UIButton *boardButton = sender;
    self.currentBoardNumber = boardButton.tag;
    [self.boardView setImage: self.boardImages[boardButton.tag]];
    
    if(self.puzzleSolved){
        [self resetPlayingPieces];
        self.puzzleSolved = NO;
    }
}

- (IBAction)solveButtonClicked:(id)sender {
    if (self.currentBoardNumber == 0 || self.puzzleSolved)
        return;
    
    NSDictionary *currentSolution = self.solutions[self.currentBoardNumber - 1];
    
    for (id key in self.playingPieces){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        
        NSDictionary *currentPieceSolution = [currentSolution objectForKey:key];
        NSNumber *originX = [currentPieceSolution objectForKey:@"x"];
        NSNumber *originY = [currentPieceSolution objectForKey:@"y"];
        NSNumber *rotations = [currentPieceSolution objectForKey:@"rotations"];
        NSNumber *flips = [currentPieceSolution objectForKey:@"flips"];
        
        UIImageView *imageView = [self.playingPieces objectForKey:key];
        imageView.transform = CGAffineTransformMakeRotation(M_PI_2*[rotations floatValue]);
        if([flips integerValue]){
            imageView.transform = CGAffineTransformScale(imageView.transform, -1.0, 1.0);
        }
        imageView.frame = CGRectMake(kBoardBlockDimension*[originX floatValue], kBoardBlockDimension*[originY floatValue], imageView.frame.size.width, imageView.frame.size.height);
        [imageView convertPoint:imageView.frame.origin toView:self.boardView];
        [self.boardView addSubview:imageView];
        
        [UIView commitAnimations];
    }
    
    self.puzzleSolved = YES;
}

- (IBAction)resetButtonClicked:(id)sender {
    [self resetPlayingPieces];
}
@end
