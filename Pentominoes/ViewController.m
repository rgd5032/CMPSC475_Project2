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

@interface ViewController ()
- (IBAction)boardButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *boardView;
@property (strong, nonatomic) NSArray *boardImages;
@property (strong, nonatomic) UIImage *currentBoardImage;
@property (strong, nonatomic) NSMutableArray *playingPieces;

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
}

-(void)viewDidAppear:(BOOL)animated
{
    self.currentBoardImage = self.boardImages[0];
    [self.boardView setImage: self.currentBoardImage];
    [self placePlayingPieces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createPlayingPieces
{
    _playingPieces = [[NSMutableArray alloc] init];
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:@"tileF.png"],
                       [UIImage imageNamed:@"tileI.png"],
                       [UIImage imageNamed:@"tileL.png"],
                       [UIImage imageNamed:@"tileN.png"],
                       [UIImage imageNamed:@"tileP.png"],
                       [UIImage imageNamed:@"tileT.png"],
                       [UIImage imageNamed:@"tileU.png"],
                       [UIImage imageNamed:@"tileV.png"],
                       [UIImage imageNamed:@"tileW.png"],
                       [UIImage imageNamed:@"tileX.png"],
                       [UIImage imageNamed:@"tileY.png"],
                       [UIImage imageNamed:@"tileZ.png"],
                       nil];
    
    for (UIImage *image in images){
        // Make the imageView frame half the size of the image, as the images are high resolution
        CGRect newFrame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = newFrame;
        [self.playingPieces addObject:imageView];
    }
}

-(void)placePlayingPieces
{   
    // Leave a padding at the beginning and end
    CGFloat rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
    CGFloat originX = kEdgePaddingForPlayingPieces;
    CGFloat originY = self.boardView.frame.origin.y + self.boardView.frame.size.height + kPaddingBetweenPiecesAndBoard;
    CGPoint currentOrigin = CGPointMake(originX, originY);
    
    for (UIImageView *imageView in self.playingPieces){
        
        // If there isn't enough space at the end of the row, start a new row
        if (rowSpaceRemaining < imageView.frame.size.width + kEdgePaddingForPlayingPieces){
            rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
            currentOrigin.y += kPlayingPieceRowHeight;
            currentOrigin.x = kEdgePaddingForPlayingPieces;
        }
        
        imageView.frame = CGRectMake(currentOrigin.x, currentOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        [self.view addSubview:imageView];
        rowSpaceRemaining -= imageView.frame.size.width + kPaddingBetweenPlayingPieces;
        currentOrigin.x = self.view.bounds.size.width - rowSpaceRemaining;
    }
}

- (IBAction)boardButtonClicked:(id)sender {
    UIButton *boardButton = sender;
    self.currentBoardImage = self.boardImages[boardButton.tag];
    [self.boardView setImage: self.currentBoardImage];
}
@end
