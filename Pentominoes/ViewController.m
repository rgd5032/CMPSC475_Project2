//
//  ViewController.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/8/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "ViewController.h"
#import "InfoViewController.h"
#import "Model.h"
#import "PlayingPieceView.h"

#define kEdgePaddingForPlayingPieces 80
#define kPaddingBetweenPlayingPieces 30.0
#define kPlayingPieceRowHeight 140
#define kPaddingBetweenPiecesAndBoard 65
#define kBoardBlockDimension 30
#define kStandardAnimationDuration 1.0
#define kPiecePanMagnification 1.5
#define kPanAnimationDuration 0.2

@interface ViewController () <InfoDelegate>

- (IBAction)boardButtonClicked:(id)sender;
- (IBAction)solveButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property (retain, nonatomic) IBOutlet UIButton *solveButton;
@property (retain, nonatomic) IBOutlet UIImageView *boardView;
@property (retain, nonatomic) NSMutableDictionary *playingPieces;
@property (retain, nonatomic) Model *model;
@property (retain, nonatomic) NSArray *themes;
@property BOOL puzzleSolved;
@property NSInteger currentTheme;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _model = [[Model alloc]init];
    _playingPieces = [[NSMutableDictionary alloc] init];
    
    UIColor *moss =[UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1];
    UIColor *honeydew = [UIColor colorWithRed:204/255.00 green:255/255.0 blue:102/255.0 alpha:1];
    UIFont *verdana_regular = [UIFont fontWithName:@"Verdana" size:28.0];
    
    UIColor *aluminum = [UIColor colorWithRed:153/255.0 green:153/255.00 blue:153/255.00 alpha:1];
    UIColor *ice = [UIColor colorWithRed:102/255.00 green:255/255.00 blue:255/255.00 alpha:1];
    UIFont *futura_condensedExtraBold =[UIFont fontWithName:@"Futura-CondensedExtraBold" size:28.0];
    
    UIColor *midnight = [UIColor colorWithRed:0/255.00 green:0/255.00 blue:128/255.00 alpha:1];
    UIColor *snow = [UIColor colorWithRed:255/255.00 green:255/255.00 blue:255/255.00 alpha:1];
    UIFont *optima_extraBlack = [UIFont fontWithName:@"Optima-ExtraBlack" size:28.0];
    
    _themes = [[NSArray alloc] initWithObjects: [[[NSDictionary alloc]initWithObjectsAndKeys:
                                                 moss,                      @"Background",
                                                 honeydew,                  @"Text",
                                                 verdana_regular,           @"Font",
                                                 nil] autorelease],
               
                                                [[[NSDictionary alloc]initWithObjectsAndKeys:
                                                 aluminum,                  @"Background",
                                                 ice,                       @"Text",
                                                 futura_condensedExtraBold, @"Font",
                                                 nil] autorelease],
               
                                                [[[NSDictionary alloc]initWithObjectsAndKeys:
                                                 midnight,                  @"Background",
                                                 snow,                      @"Text",
                                                 optima_extraBlack,         @"Font",
                                                 nil] autorelease],
                                                nil];
    self.currentTheme = 0;
    
    NSDictionary *pieces = [[self.model createPlayingPieceImages] retain];
    for (id key in pieces){
        UIImage *image = [pieces objectForKey:key];
        PlayingPieceView *imageView = [[PlayingPieceView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        imageView.userInteractionEnabled = YES;
        [self addPlayingPieceGestures:imageView];
        [self.playingPieces setObject:imageView forKey:key];
        [imageView release];
    }
    
    [pieces release];
}

-(void)dealloc
{
    [_model release];
    [_playingPieces release];
    [_boardView release];
    [_themes release];
    [_resetButton release];
    [_solveButton release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.model.currentBoardNumber = 0;
    UIImage *image = [self.model getBoardImage:self.model.currentBoardNumber];
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
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
        
        PlayingPieceView *playingPieceView = [self.playingPieces objectForKey:key];
        playingPieceView.transform = CGAffineTransformIdentity;
        playingPieceView.isFlipped = NO;
        // If there isn't enough space at the end of the row, start a new row
        if (rowSpaceRemaining < playingPieceView.frame.size.width + kEdgePaddingForPlayingPieces){
            rowSpaceRemaining = self.view.bounds.size.width - kEdgePaddingForPlayingPieces;
            currentOrigin.y += kPlayingPieceRowHeight;
            currentOrigin.x = kEdgePaddingForPlayingPieces;
        }
        
        CGPoint convertedOrigin = [playingPieceView.superview convertPoint:playingPieceView.frame.origin toView:self.view];
        playingPieceView.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, playingPieceView.frame.size.width, playingPieceView.frame.size.height);
        [self.view addSubview:playingPieceView];
        playingPieceView.frame = CGRectMake(currentOrigin.x, currentOrigin.y, playingPieceView.frame.size.width, playingPieceView.frame.size.height);
        rowSpaceRemaining -= playingPieceView.frame.size.width + kPaddingBetweenPlayingPieces;
        currentOrigin.x = self.view.bounds.size.width - rowSpaceRemaining;
    }
}

-(void)addPlayingPieceGestures:(UIView*)imageView
{
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pieceDoubleTapped:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [imageView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pieceSingleTapped:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [imageView addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(piecePanRecognized:)];
    [imageView addGestureRecognizer:panGesture];
    [panGesture release];
}

-(void) resetPlayingPieces
{
    void (^animate)() = ^{
            [self placePlayingPieces];
    };
        
    [UIView animateWithDuration:kStandardAnimationDuration animations:animate];
    
    self.puzzleSolved = NO;
    self.boardView.userInteractionEnabled = YES;
}

#pragma mark - IBActions

- (IBAction)boardButtonClicked:(id)sender {
    UIButton *boardButton = sender;
    self.model.currentBoardNumber = boardButton.tag;
    UIImage *image = [self.model getBoardImage:boardButton.tag];
    [self.boardView setImage: image];
    
    [self resetPlayingPieces];
    self.puzzleSolved = NO;
}

- (IBAction)solveButtonClicked:(id)sender {
    if (self.model.currentBoardNumber == 0 || self.puzzleSolved)
        return;
    
    NSDictionary *currentSolution = [self.model getSolution:self.model.currentBoardNumber];
    
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
        
        [UIView animateWithDuration:kStandardAnimationDuration animations:animate];
    }
    
    self.puzzleSolved = YES;
    self.boardView.userInteractionEnabled = NO;
}

- (IBAction)resetButtonClicked:(id)sender {
    [self resetPlayingPieces];
}

#pragma mark - Info Delegate
-(void)dismissMe:(NSInteger)currentTheme {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.currentTheme = currentTheme;
    
    UIColor *backgroundColor = [self.themes[self.currentTheme] objectForKey:@"Background"];
    UIColor *textColor = [self.themes[self.currentTheme] objectForKey:@"Text"];
    UIFont *font = [self.themes[self.currentTheme] objectForKey:@"Font"];
    
    self.view.backgroundColor = backgroundColor;
    self.resetButton.titleLabel.font = font;
    self.resetButton.titleLabel.textColor = textColor;
    self.solveButton.titleLabel.font = font;
    self.solveButton.titleLabel.textColor = textColor;
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InfoSegue"]) {
        InfoViewController *infoViewController = segue.destinationViewController;
        infoViewController.currentTheme = self.currentTheme;
        infoViewController.delegate = self;
    }
}

#pragma mark - GestureRecognizers
-(void)pieceSingleTapped:(UITapGestureRecognizer*)recognizer
{
    PlayingPieceView *singleTappedPiece = (PlayingPieceView*)recognizer.view;
    
    void (^animate)() = ^{
        if (singleTappedPiece.isFlipped){
            singleTappedPiece.transform = CGAffineTransformRotate(singleTappedPiece.transform, -M_PI_2);
        }
        else{
            singleTappedPiece.transform = CGAffineTransformRotate(singleTappedPiece.transform, M_PI_2);
        }
    };
    
    [UIView animateWithDuration:kStandardAnimationDuration animations:animate];
}

-(void)pieceDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    PlayingPieceView *doubleTappedPiece = (PlayingPieceView*)recognizer.view;
    
    void (^animate)() = ^{
        doubleTappedPiece.transform = CGAffineTransformScale(doubleTappedPiece.transform, -1.0, 1.0);
    };
    
    doubleTappedPiece.isFlipped = !doubleTappedPiece.isFlipped;
    
    [UIView animateWithDuration:kStandardAnimationDuration animations:animate];
}

-(void)piecePanRecognized:(UIPanGestureRecognizer*)recognizer
{
    UIView *pannedPiece = recognizer.view;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            pannedPiece.transform = CGAffineTransformScale(pannedPiece.transform, kPiecePanMagnification, kPiecePanMagnification);
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            pannedPiece.center = [recognizer locationInView:pannedPiece.superview];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {            
            // Place the piece's imageView in the correct superview
            UIView *newSuperView;
            CGPoint newOrigin;
            
            pannedPiece.transform = CGAffineTransformScale(pannedPiece.transform, 1/kPiecePanMagnification, 1/kPiecePanMagnification);
            
            CGPoint endingOriginInView = [pannedPiece.superview convertPoint:pannedPiece.frame.origin toView:self.view];
            pannedPiece.frame = CGRectMake(endingOriginInView.x, endingOriginInView.y, pannedPiece.frame.size.width, pannedPiece.frame.size.height);
            [self.view addSubview:pannedPiece];
            
            CGPoint pieceBottomRight = CGPointMake(pannedPiece.frame.origin.x + pannedPiece.frame.size.width, pannedPiece.frame.origin.y + pannedPiece.frame.size.height);
            
            if(CGRectContainsPoint(self.boardView.frame, pannedPiece.frame.origin) && CGRectContainsPoint(self.boardView.frame, pieceBottomRight)){
                newSuperView = self.boardView;
                newOrigin = [pannedPiece.superview convertPoint:pannedPiece.frame.origin toView:newSuperView];
                pannedPiece.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedPiece.frame.size.width, pannedPiece.frame.size.height);
                CGFloat snapOriginX = kBoardBlockDimension*floorf((newOrigin.x/kBoardBlockDimension)+0.5);
                CGFloat snapOriginY = kBoardBlockDimension*floorf((newOrigin.y/kBoardBlockDimension)+0.5);
                newOrigin = CGPointMake(snapOriginX, snapOriginY);
            }
            else{
                newSuperView = self.view;
                newOrigin = [pannedPiece.superview convertPoint:pannedPiece.frame.origin toView:newSuperView];
            }
            
            if (newSuperView != pannedPiece.superview){
             [newSuperView addSubview:pannedPiece];
             pannedPiece.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedPiece.frame.size.width, pannedPiece.frame.size.height);
            }
            break;
             
             
        }
        default:
            break;
    }
}

@end
