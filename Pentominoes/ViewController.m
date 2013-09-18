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
@property NSMutableDictionary *playingPieces;

@property Model *model;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _model = [[Model alloc]init];
    _playingPieces = [[NSMutableDictionary alloc] init];
    
    NSDictionary *pieces = [self.model createPlayingPieceImages];
    for (id key in pieces){
        UIImage *image = [pieces objectForKey:key];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        imageView.userInteractionEnabled = YES;
        [self.playingPieces setObject:imageView forKey:key];
    }
    
    self.puzzleSolved = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.currentBoardNumber = 0;
    UIImage *image = [self.model getBoardImage:self.currentBoardNumber];
    [self.boardView setImage: image];
    [self placePlayingPieces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resetPlayingPieces];
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
        
        CGPoint convertedOrigin = [imageView.superview convertPoint:imageView.frame.origin toView:self.view];
        imageView.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        [self.view addSubview:imageView];
        imageView.frame = CGRectMake(currentOrigin.x, currentOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
        rowSpaceRemaining -= imageView.frame.size.width + kPaddingBetweenPlayingPieces;
        currentOrigin.x = self.view.bounds.size.width - rowSpaceRemaining;
        
        [self addPlayingPieceGestures:imageView];
    }
}

-(void)addPlayingPieceGestures:(UIView*)imageView
{
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

-(void)pieceSingleTapped:(UITapGestureRecognizer*)recognizer
{
    UIView *singleTappedPiece = recognizer.view;
    
    void (^animate)() = ^{
        singleTappedPiece.transform = CGAffineTransformRotate(singleTappedPiece.transform, M_PI_2);
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){};
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animate
                     completion:completion];
}

-(void)pieceDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    UIView *doubleTappedPiece = recognizer.view;
    
    void (^animate)() = ^{
        doubleTappedPiece.transform = CGAffineTransformScale(doubleTappedPiece.transform, -1.0, 1.0);
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){};
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animate
                     completion:completion];
}

-(void)piecePanRecognized:(UIPanGestureRecognizer*)recognizer
{
    UIView *pannedPiece = recognizer.view;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            pannedPiece.transform = CGAffineTransformScale(pannedPiece.transform, 1.5, 1.5);
        }
        case UIGestureRecognizerStateChanged:
        {
            void (^animate)() = ^{
                
                pannedPiece.center = [recognizer locationInView:self.view];
            };
            
            void (^completion)(BOOL) = ^(BOOL finished){};
            
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:animate
                             completion:completion];

            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            // Place the piece's imageView in the correct superview
            UIView *newSuperView;
            CGPoint newOrigin;
            
            pannedPiece.transform = CGAffineTransformScale(pannedPiece.transform, 2/3.0, 2/3.0);
            
            if(CGRectContainsPoint(self.boardView.frame, pannedPiece.frame.origin)){
                newSuperView = self.boardView;
                newOrigin = [pannedPiece.superview convertPoint:pannedPiece.frame.origin toView:self.boardView];
                pannedPiece.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedPiece.frame.size.width, pannedPiece.frame.size.height);
                CGFloat snapOriginX = 30.0*floorf((newOrigin.x/30.0)+0.5);
                CGFloat snapOriginY = 30.0*floorf((newOrigin.y/30.0)+0.5);
                newOrigin = CGPointMake(snapOriginX, snapOriginY);
            }
            else{
                newSuperView = self.view;
                newOrigin = pannedPiece.frame.origin;
            }
            
            if (newSuperView != pannedPiece.superview){
                [newSuperView addSubview:pannedPiece];
                
                void (^animate)() = ^{
                    pannedPiece.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedPiece.frame.size.width, pannedPiece.frame.size.height);
                };
                
                void (^completion)(BOOL) = ^(BOOL finished){};
                
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:animate
                                 completion:completion];
            }
            break;
        }
        default:
            break;
    }
}

-(void) resetPlayingPieces
{
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

- (IBAction)boardButtonClicked:(id)sender {
    UIButton *boardButton = sender;
    self.currentBoardNumber = boardButton.tag;
    UIImage *image = [self.model getBoardImage:boardButton.tag];
    [self.boardView setImage: image];
    
    if(self.puzzleSolved){
        [self resetPlayingPieces];
        self.puzzleSolved = NO;
    }
}

- (IBAction)solveButtonClicked:(id)sender {
    if (self.currentBoardNumber == 0 || self.puzzleSolved)
        return;
    
    NSDictionary *currentSolution = [self.model getSolution:self.currentBoardNumber];
    
    for (id key in self.playingPieces){
        NSDictionary *currentPieceSolution = [currentSolution objectForKey:key];
        NSNumber *originX = [currentPieceSolution objectForKey:@"x"];
        NSNumber *originY = [currentPieceSolution objectForKey:@"y"];
        NSNumber *rotations = [currentPieceSolution objectForKey:@"rotations"];
        NSNumber *flips = [currentPieceSolution objectForKey:@"flips"];
        
        UIImageView *imageView = [self.playingPieces objectForKey:key];
        
        void (^animate)() = ^{
            CGPoint convertedOrigin = [imageView.superview convertPoint:imageView.frame.origin toView:self.boardView];
            imageView.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, imageView.frame.size.width, imageView.frame.size.height);
            [self.boardView addSubview:imageView];
            imageView.transform = CGAffineTransformIdentity;
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
