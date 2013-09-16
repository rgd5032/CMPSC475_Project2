//
//  Model.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "Model.h"

@implementation Model

-(id)init {
    self = [super init];
    if (self) {
        _boardImages = [self createBoardImages];
        _playingPieces = [self createPlayingPieces];
        _solutions = [self createSolutions];
    }
    return self;
}

-(NSMutableDictionary*)createPlayingPieces {
    NSMutableDictionary *pieces = [[NSMutableDictionary alloc] init];
    NSArray *playingPieceNames = @[@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    for (NSString *name in playingPieceNames)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tile%@", name]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        [pieces setObject:imageView forKey:name];
    }
    
    return pieces;
}

-(NSArray*)createBoardImages {
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

@end
