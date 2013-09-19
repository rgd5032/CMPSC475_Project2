//
//  InfoViewController.h
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/18/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InfoDelegate <NSObject>

-(void)dismissMe;

@end

@interface InfoViewController : UIViewController
@property (nonatomic,weak) id<InfoDelegate> delegate;

@end
