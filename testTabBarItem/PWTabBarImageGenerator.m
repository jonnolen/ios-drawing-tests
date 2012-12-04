//
//  PWTabBarImageGenerator.m
//  passageways
//
//  Created by Jonathan Nolen on 12/4/12.
//  Copyright (c) 2012 Developertown. All rights reserved.
//

#import "PWTabBarImageGenerator.h"
#import <QuartzCore/QuartzCore.h>

#define NC(x) x / 255.0

@interface PWTabBarImageGenerator(){
    UIImage * _selectedImage;
    UIImage * _unselectedImage;
    UIImage * _backgroundImage;
    UIImage *_iconImage;
    CGSize _iconSize;
    CGRect _iconBounds;
    CGSize _targetSize;
    CGRect _targetBounds;
}

@end

@implementation PWTabBarImageGenerator

-(id)initWithIconSize:(CGSize)iconSize imageSize:(CGSize)targetSize iconImage:(UIImage *)icon{
    if ((self = [super init])){
        _iconImage = icon;

        _targetSize = targetSize;
        _targetBounds.origin = CGPointZero;
        _targetBounds.size = _targetSize;
        
        _iconSize = iconSize;
        _iconBounds.origin = CGPointZero;
        _iconBounds.size = _iconSize;
        
        self.iconColor = [UIColor lightGrayColor];
        self.addShine = YES;
    }
    return self;
}

-(UIImage *)unselectedImage{
    if (!_unselectedImage){
        _unselectedImage = [self createUnselectedImage];
    }
    return _unselectedImage;
}

-(UIImage *)createUnselectedImage{
    UIImage *icon = [self createUnselectedIcon];
    return [self iconRenderedInTarget:icon];
}

-(UIImage *)iconRenderedInTarget:(UIImage *)icon{
    CGContextRef ctx = [self newImageContextWithSize:_targetSize];
    CGRect iconInTargetBounds = CGRectInset(_targetBounds, floorf((_targetSize.width - _iconSize.width) / 2),  floorf((_targetSize.height - _iconSize.height)/2));
    [self setCTM:ctx forSize:_targetSize];
    CGContextSetShadow(ctx, CGSizeMake(2.0, 2.0), 1.0);
    CGContextBeginTransparencyLayer(ctx, NULL);
    CGContextDrawImage(ctx, iconInTargetBounds, [icon CGImage]);
    CGContextEndTransparencyLayer(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

-(UIImage *)createUnselectedIcon{
    CGContextRef ctx =  [self newImageContextWithSize:_iconSize];;

    [self drawIconUnselectedColor:ctx];
    [self compositeIcon:ctx];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(void)drawIconUnselectedColor:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextSetFillColorWithColor(ctx, [self.iconColor CGColor]);
    CGContextFillRect(ctx, _iconBounds);
    CGContextRestoreGState(ctx);
}

-(void)compositeIcon:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    [self setCTM:ctx forSize:_iconSize];
    CGContextSetBlendMode(ctx, kCGBlendModeDestinationIn);
    CGContextDrawImage(ctx, _iconBounds, [_iconImage CGImage]);
    CGContextRestoreGState(ctx);
}
-(void)setCTM:(CGContextRef)ctx forSize:(CGSize)size{
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
}
-(UIImage *)selectedImage{
    if (!_selectedImage){
        _selectedImage = [self createSelectedImage];
    }
    return _selectedImage;
}

-(UIImage *)createSelectedImage{
    UIImage * icon = [self createSelectedIcon];
    
    return [self iconRenderedInTarget:icon];
}

-(UIImage *)createSelectedIcon{
    CGContextRef ctx = [self newImageContextWithSize:_iconSize];
    [self drawIconSelectedGradient:ctx];
    if (self.addShine){
        [self drawShine:ctx];
    }
    [self compositeIcon:ctx];

    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return icon;
}

-(void)drawIconSelectedGradient:(CGContextRef)ctx{
    size_t num_locations = 2;
	CGFloat locations[2] = { 0.3, 1.0 };
    
	CGFloat components[8] = {NC(72), NC(122), NC(229), 1.0, NC(110), NC(202), NC(255), 1.0 };
    
    CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint = CGPointZero;
    CGPoint ePoint = CGPointMake(0, _iconSize.height);

    CGContextSaveGState(ctx);
	CGContextDrawLinearGradient (ctx, gradient, sPoint, ePoint, kCGGradientDrawsBeforeStartLocation| kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(cspace);
}

-(void)drawShine:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    
    [self addShineClip:ctx];
    [self drawShineGradient:ctx];

    CGContextRestoreGState(ctx);
}

-(void)addShineClip:(CGContextRef)ctx{
    CGContextMoveToPoint(ctx, 0.0, floorf(_iconSize.height * 2 / 3));
    CGContextAddQuadCurveToPoint(ctx, floorf(_iconSize.width / 3), floorf(_iconSize.height / 2), _iconSize.width, floorf(_iconSize.height / 3));
    CGContextAddLineToPoint(ctx, _iconSize.width, 0);
    CGContextAddLineToPoint(ctx, 0, 0);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
}

-(void)drawShineGradient:(CGContextRef)ctx{
    size_t num_locations = 2;
	CGFloat locations[2] = { 0.3, 0.7};
	CGFloat components[8] = {1.0, 1.0, 1.0, 0.8, 1.0, 1.0, 1.0, 0.0};
    
    CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint = CGPointMake(floorf(_iconSize.width / 3), 0);
    CGPoint ePoint = CGPointMake(floorf(_iconSize.width * 2 / 3), _iconSize.height);
    
    CGContextDrawLinearGradient(ctx, gradient, sPoint, ePoint, kCGGradientDrawsBeforeStartLocation);

    CGColorSpaceRelease(cspace);
    CGGradientRelease(gradient);
}
-(CGContextRef)newImageContextWithSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    return ctx;
}
@end
