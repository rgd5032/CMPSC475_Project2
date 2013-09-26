//
//  InfoViewController.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/18/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
- (IBAction)dismissPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *theme0CheckBox;
@property (retain, nonatomic) IBOutlet UILabel *theme1CheckBox;
@property (retain, nonatomic) IBOutlet UILabel *theme2CheckBox;
- (IBAction)themeButtonPressed:(id)sender;

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    switch (self.currentTheme){
        case 0:
            self.theme0CheckBox.text = @"X";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"";
            break;
        case 1:
            self.theme0CheckBox.text = @"";
            self.theme1CheckBox.text = @"X";
            self.theme2CheckBox.text = @"";
            break;
        case 2:
            self.theme0CheckBox.text = @"";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"X";
            break;
        default:
            self.theme0CheckBox.text = @"X";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"";
            break;            
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPressed:(id)sender {
    [self.delegate dismissMe:self.currentTheme];
}

- (void)dealloc {
    [_theme0CheckBox release];
    [_theme1CheckBox release];
    [_theme2CheckBox release];
    [super dealloc];
}
- (IBAction)themeButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            self.theme0CheckBox.text = @"X";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"";
            break;
        case 1:
            self.theme0CheckBox.text = @"";
            self.theme1CheckBox.text = @"X";
            self.theme2CheckBox.text = @"";
            break;
        case 2:
            self.theme0CheckBox.text = @"";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"X";
            break;
        default:
            self.theme0CheckBox.text = @"X";
            self.theme1CheckBox.text = @"";
            self.theme2CheckBox.text = @"";
            break;
    }
    self.currentTheme = button.tag;
}
@end
