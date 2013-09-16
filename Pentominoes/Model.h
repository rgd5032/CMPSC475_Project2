//
//  Model.h
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (strong, nonatomic, readonly) NSArray *boardImages;
@property (strong, nonatomic, readonly) NSMutableDictionary *playingPieces;
@property (strong, nonatomic, readonly) NSArray *solutions;
-(NSMutableDictionary*)createPlayingPieces;
-(NSArray*)createBoardImages;
@end
