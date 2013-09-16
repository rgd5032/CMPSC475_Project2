//
//  ViewController.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/8/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

#define kEdgePaddingForPlayingPieces 80
#define kPaddingBetweenPlayingPieces 30
#define kPlayingPieceRowHeight 140
#define kPaddingBetweenPiecesAndBoard 40
#define kBoardBlockDimension 30
#define kAnimationDuration 1.0

@interface ViewController ()
- (IBAction)boardButtonClicked:(id)sender;
- (IBAction)solveButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *boardView;
@property NSInteger currentBoardNumber;
@property BOOL puzzleSolved;

@property Model *model;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _model = [[Model alloc]init];
    
    
    self.puzzleSolved = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.currentBoardNumber = 0;
    [self.boardView setImage: self.model.boardImages[self.currentBoardNumber]];
    [self placePlayingPieces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self placePlayingPieces];
}

-(void)placePlayingPieces
{   
    // Leave a padding at the beginning and end
    CGFloat rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
    CGFloat originX = kEdgePaddingForPlayingPieces;
    CGFloat originY = self.boardView.frame.origin.y + self.boardView.frame.size.height + kPaddingBetweenPiecesAndBoard;
    CGPoint currentOrigin = CGPointMake(originX, originY);
    
    for (id key in self.model.playingPieces){
        
        UIImageView *imageView = [self.model.playingPieces objectForKey:key];
        imageView.transform = CGAffineTransformIdentity;
        // If there isn't enough space at the end of the row, start a new row
        if (rowSpaceRemaining < imageView.frame.size.width + kEdgePaddingForPlayingPieces){
            rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
            currentOrigin.y += kPlayingPieceRowHeight;
            currentOrigin.x = kEdgePaddingForPlayingPieces;
        }
        
        CGPoint convertedOrigin = [imageView.superview convertPoint:imageView.frame.origin toView:self.view];
        imageView.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        [self.view addSubview:imageView];
        imageView.frame = CGRectMake(currentOrigin.x, currentOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        rowSpaceRemaining -= imageView.frame.size.width + kPaddingBetweenPlayingPieces;
        currentOrigin.x = self.view.bounds.size.width - rowSpaceRemaining;
        
        
        
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pieceDoubleTapped:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pieceSingleTapped:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [imageView addGestureRecognizer:singleTapGesture];
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(piecePanRecognized:)];
        [imageView addGestureRecognizer:panGesture];
    }
}

-(void)pieceSingleTapped:(UITapGestureRecognizer*)recognizer {
    UIView *singleTappedPiece = recognizer.view;
    singleTappedPiece.transform = CGAffineTransformRotate(singleTappedPiece.transform, M_PI_2);
}

-(void)pieceDoubleTapped:(UITapGestureRecognizer*)recognizer {
    UIView *doubleTappedPiece = recognizer.view;
    doubleTappedPiece.transform = CGAffineTransformScale(doubleTappedPiece.transform, -1.0, 1.0);
}

-(void)piecePanRecognized:(UIPanGestureRecognizer*)recognizer {
    UIView *pannedPiece = recognizer.view;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
            //TODO: add to board view??
            pannedPiece.center = [recognizer locationInView:self.view];
            break;
        case UIGestureRecognizerStateEnded:
            //TODO: Snap into place
            break;
        default:
            break;
    }
}

-(void) resetPlayingPieces
{
    if (self.puzzleSolved){
        void (^animate)() = ^{
            [self placePlayingPieces];
        };
        
        void (^completion)(BOOL) = ^(BOOL finished){};
        
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animate
                         completion:completion];

        self.puzzleSolved = NO;
    }
}

- (IBAction)boardButtonClicked:(id)sender {
    UIButton *boardButton = sender;
    self.currentBoardNumber = boardButton.tag;
    [self.boardView setImage: self.model.boardImages[boardButton.tag]];
    
    if(self.puzzleSolved){
        [self resetPlayingPieces];
        self.puzzleSolved = NO;
    }
}

- (IBAction)solveButtonClicked:(id)sender {
    if (self.currentBoardNumber == 0 || self.puzzleSolved)
        return;
    
    NSDictionary *currentSolution = self.model.solutions[self.currentBoardNumber - 1];
    
    for (id key in self.model.playingPieces){
        NSDictionary *currentPieceSolution = [currentSolution objectForKey:key];
        NSNumber *originX = [currentPieceSolution objectForKey:@"x"];
        NSNumber *originY = [currentPieceSolution objectForKey:@"y"];
        NSNumber *rotations = [currentPieceSolution objectForKey:@"rotations"];
        NSNumber *flips = [currentPieceSolution objectForKey:@"flips"];
        
        UIImageView *imageView = [self.model.playingPieces objectForKey:key];
        
        void (^animate)() = ^{
            CGPoint convertedOrigin = [imageView.superview convertPoint:imageView.frame.origin toView:self.boardView];
            imageView.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
            [self.boardView addSubview:imageView];
            imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI_2*[rotations floatValue]);
            if([flips integerValue]){
                imageView.transform = CGAffineTransformScale(imageView.transform, -1.0, 1.0);
            }
            imageView.frame = CGRectMake(kBoardBlockDimension*[originX floatValue], kBoardBlockDimension*[originY floatValue], imageView.frame.size.width, imageView.frame.size.height);
            
        };
        
        void (^completion)(BOOL) = ^(BOOL finished){};
        
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animate
                         completion:completion];
    }
    
    self.puzzleSolved = YES;
}

- (IBAction)resetButtonClicked:(id)sender {
    [self resetPlayingPieces];
}
@end
