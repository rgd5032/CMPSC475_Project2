//
//  PlayingPieceView.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/24/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "PlayingPieceView.h"

@implementation PlayingPieceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isFlipped = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
