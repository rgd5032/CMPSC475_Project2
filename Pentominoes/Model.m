//
//  Model.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "Model.h"

@interface Model ()
@property (strong, nonatomic) NSArray *boardImages;
@property (strong, nonatomic) NSArray *solutions;
@end

@implementation Model

-(id)init
{
    self = [super init];
    if (self) {
        _solutions = [self createSolutions];
        _boardImages = [self createBoardImages];
        _currentBoardNumber = 0;
    }
    return self;
}

-(NSDictionary*)createPlayingPieceImages
{
    NSMutableDictionary *pieces = [[NSMutableDictionary alloc] init];
    NSArray *playingPieceNames = @[@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    for (NSString *name in playingPieceNames)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tile%@", name]];
        [pieces setObject:image forKey:name];
    }
    
    return pieces;
}

-(NSArray*)createBoardImages
{
    NSArray *boardImages = [[NSArray alloc] initWithObjects:
                            [UIImage imageNamed:@"Board0.png"],
                            [UIImage imageNamed:@"Board1.png"],
                            [UIImage imageNamed:@"Board2.png"],
                            [UIImage imageNamed:@"Board3.png"],
                            [UIImage imageNamed:@"Board4.png"],
                            [UIImage imageNamed:@"Board5.png"],
                            nil];
    
    return boardImages;
}

-(NSArray*)createSolutions {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"Solutions" ofType:@"plist"];
    NSArray *solutions = [NSArray arrayWithContentsOfFile:path];
    return solutions;
}

-(NSDictionary*)getSolution:(NSInteger)boardNumber
{
    NSDictionary *solution = [[NSDictionary alloc] initWithDictionary:self.solutions[boardNumber-1]];
    return solution;
}

-(UIImage*)getBoardImage:(NSInteger)boardNumber
{
    return self.boardImages[boardNumber];
}
@end
