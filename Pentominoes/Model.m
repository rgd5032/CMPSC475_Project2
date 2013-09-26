//
//  Model.m
//  Pentominoes
//
//  Created by ROBERT GERALD DICK on 9/16/13.
//  Copyright (c) 2013 ROBERT GERALD DICK. All rights reserved.
//

#import "Model.h"

@interface Model ()
@property (retain, nonatomic) NSArray *boardImages;
@property (retain, nonatomic) NSArray *solutions;
@property (retain, nonatomic) NSArray *themes;
@end

@implementation Model

-(id)init
{
    self = [super init];
    if (self) {
        _solutions = [[self allSolutions] retain];
        _boardImages = [[self allBoardImages] retain];
        _themes = [[self allThemes] retain];
        _currentBoardNumber = 0;
    }
    return self;
}

-(void)dealloc
{
    [_solutions release];
    [_boardImages release];
    [_themes release];
    [super dealloc];
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
    
    return [pieces autorelease];
}

-(NSArray*)allBoardImages
{
    NSArray *boardImages = [[NSArray alloc] initWithObjects:
                            [UIImage imageNamed:@"Board0.png"],
                            [UIImage imageNamed:@"Board1.png"],
                            [UIImage imageNamed:@"Board2.png"],
                            [UIImage imageNamed:@"Board3.png"],
                            [UIImage imageNamed:@"Board4.png"],
                            [UIImage imageNamed:@"Board5.png"],
                            nil];
    
    return [boardImages autorelease];
}

-(NSArray*)allThemes
{
    UIColor *moss =[UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1];
    UIColor *honeydew = [UIColor colorWithRed:204/255.00 green:255/255.0 blue:102/255.0 alpha:1];
    UIFont *verdana_regular = [UIFont fontWithName:@"Verdana" size:28.0];
    NSDictionary *classicTheme = [[[NSDictionary alloc]initWithObjectsAndKeys:
                                   moss,             @"Background",
                                   honeydew,         @"Text",
                                   verdana_regular,  @"Font",
                                   nil] autorelease];
    
    UIColor *aluminum = [UIColor colorWithRed:153/255.0 green:153/255.00 blue:153/255.00 alpha:1];
    UIColor *ice = [UIColor colorWithRed:102/255.00 green:255/255.00 blue:255/255.00 alpha:1];
    UIFont *futura_condensedExtraBold =[UIFont fontWithName:@"Futura-CondensedExtraBold" size:28.0];
    NSDictionary *metalTheme = [[[NSDictionary alloc]initWithObjectsAndKeys:
                                 aluminum,                  @"Background",
                                 ice,                       @"Text",
                                 futura_condensedExtraBold, @"Font",
                                 nil] autorelease];
    
    UIColor *midnight = [UIColor colorWithRed:0/255.00 green:0/255.00 blue:128/255.00 alpha:1];
    UIColor *snow = [UIColor colorWithRed:255/255.00 green:255/255.00 blue:255/255.00 alpha:1];
    UIFont *optima_extraBlack = [UIFont fontWithName:@"Optima-ExtraBlack" size:28.0];
    NSDictionary *nittanyLionTheme = [[[NSDictionary alloc]initWithObjectsAndKeys:
                                       midnight,          @"Background",
                                       snow,              @"Text",
                                       optima_extraBlack, @"Font",
                                       nil] autorelease];
    
    NSArray *themes = [[NSArray alloc] initWithObjects: classicTheme, metalTheme, nittanyLionTheme, nil];

    return [themes autorelease];
}

-(NSArray*)allSolutions {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"Solutions" ofType:@"plist"];
    NSArray *solutions = [NSArray arrayWithContentsOfFile:path];
    return solutions;
}

-(NSDictionary*)getSolution:(NSInteger)boardNumber
{
    NSDictionary *solution = [[NSDictionary alloc] initWithDictionary:self.solutions[boardNumber-1]];
    return [solution autorelease];
}

-(UIImage*)getBoardImage:(NSInteger)boardNumber
{
    return self.boardImages[boardNumber];
}

-(UIColor*)getBackgroundColorForTheme:(NSInteger)themeNumber
{
    UIColor *color = [self.themes[themeNumber] objectForKey:@"Background"];
    return color;
}

-(UIColor*)getTextColorForTheme:(NSInteger)themeNumber
{
    UIColor *color = [self.themes[themeNumber] objectForKey:@"Text"];
    return color;
}

-(UIFont*)getFontForTheme:(NSInteger)themeNumber
{
    UIFont *font = [self.themes[themeNumber] objectForKey:@"Font"];
    return font;
}
@end
