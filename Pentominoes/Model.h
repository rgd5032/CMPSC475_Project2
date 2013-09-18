//
//  Model.h
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
-(NSDictionary*)createPlayingPieceImages;
-(NSArray*)createBoardImages;
-(UIImage*)getBoardImage:(NSInteger)boardNumber;
-(NSDictionary*)getSolution:(NSInteger)boardNumber;
@end
