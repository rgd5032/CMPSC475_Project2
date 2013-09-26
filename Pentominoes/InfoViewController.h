//
//  InfoViewController.h
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/18/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InfoDelegate <NSObject>

-(void)dismissMe:(NSInteger)currentTheme;

@end

@interface InfoViewController : UIViewController
@property (nonatomic,retain) id<InfoDelegate> delegate;
@property NSInteger currentTheme;

@end
