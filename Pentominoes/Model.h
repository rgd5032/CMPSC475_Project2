//
//  Model.h
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property NSInteger currentBoardNumber;
-(NSDictionary*)createPlayingPieceImages;
-(UIImage*)getBoardImage:(NSInteger)boardNumber;
-(NSDictionary*)getSolution:(NSInteger)boardNumber;
-(UIColor*)getBackgroundColorForTheme:(NSInteger)themeNumber;
-(UIColor*)getTextColorForTheme:(NSInteger)themeNumber;
-(UIFont*)getFontForTheme:(NSInteger)themeNumber;
@end
