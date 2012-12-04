//
//  PWTabBarImageGenerator.h
//  passageways
//
//  Created by Jonathan Nolen on 12/4/12.
//  Copyright (c) 2012 Developertown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWTabBarImageGenerator : NSObject

@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, assign) BOOL addShine;

-(id)initWithIconSize:(CGSize)iconSize imageSize:(CGSize)targetSize iconImage:(UIImage *)icon;
-(UIImage *)unselectedImage;
-(UIImage *)selectedImage;

@end
