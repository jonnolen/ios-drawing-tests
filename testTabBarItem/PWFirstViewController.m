//
//  PWFirstViewController.m
//  testTabBarItem
//
//  Created by Jonathan Nolen on 12/2/12.
//  Copyright (c) 2012 Developertown. All rights reserved.
//

#import "PWFirstViewController.h"
#define NC(x) x / 255.0
@interface PWFirstViewController ()

@end

@implementation PWFirstViewController

-(UIImage *)tabBarImage{
    
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    
    UIImage *image = [UIImage imageNamed:@"plus_icon"];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, 60);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    CGContextFillRect(ctx, CGRectMake(0, 0, 60, 60));
    
    CGRect imageRect = CGRectMake(15, 15, 30, 30);
    [image drawInRect:imageRect];


    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)sourceImage{
    UIGraphicsBeginImageContext(CGSizeMake(60.0, 60.0));

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, 60);
    CGContextScaleCTM(context, 1.0, -1.0);

    size_t num_locations = 2;
	CGFloat locations[2] = { 0.3, 1.0 };

	CGFloat components[8] = {NC(72), NC(122), NC(229), 1.0, NC(110), NC(202), NC(255), 1.0 };

    CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint = CGPointMake(0.0, 15.0);
    CGPoint ePoint = CGPointMake(0.0, 45.0);
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, kCGGradientDrawsBeforeStartLocation| kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(cspace);
    [self addShineToContext:context];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    
    return image;
}

-(void)addShineToContext:(CGContextRef) context{
    CGContextSaveGState(context);
    size_t num_locations = 2;
	CGFloat locations[2] = { 0.3, 0.7};
	CGFloat components[8] = {1.0, 1.0, 1.0, 0.8, 1.0, 1.0, 1.0, 0.0};//{0.82, 0.82, 0.82, 0.4,  0.92, 0.92, 0.92, .8 };
    
    CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint = CGPointMake(25.0f, 15.0);
    CGPoint ePoint = CGPointMake(35.0f, 44.0f);
    
    
    [self addShineClip:context];

    CGContextDrawLinearGradient(context, gradient, sPoint, ePoint, kCGGradientDrawsBeforeStartLocation);
//    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
//    CGContextFillRect(context, CGRectMake(15,15, 30, 30));

    CGColorSpaceRelease(cspace);
    CGGradientRelease(gradient);

    CGContextRestoreGState(context);
    
}

-(void)addShineClip:(CGContextRef)context{
    CGContextMoveToPoint(context, 15, 35);
    CGContextAddQuadCurveToPoint(context, 25, 30, 45, 28);
    CGContextAddLineToPoint(context, 45, 15);
    CGContextAddLineToPoint(context, 15, 15);
    CGContextClosePath(context);
    CGContextClip(context);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView1.image = [self compositeOverSlate:[self drawTabBarOverSourceWithBlend:kCGBlendModeSourceIn]];
    self.imageView2.image = [self compositeOverSlate:[self drawTabBarOverSourceWithBlend:kCGBlendModeDestinationIn]];
    self.imageView3.image = [self compositeOverSlate:[self drawTabBarOverSourceWithBlend:kCGBlendModeSourceAtop]];
    self.imageView4.image = [self compositeOverSlate:[self drawTabBarOverSourceWithBlend:kCGBlendModeDestinationAtop]];
}

-(UIImage *)compositeOverSlate:(UIImage *)image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, 60);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CGRect imageRect = CGRectMake(0, 0, 0, 0);
    imageRect.size = image.size;
        
    CGContextSetFillColorWithColor(ctx, [[UIColor darkGrayColor] CGColor]);
    
    CGContextFillRect(ctx, imageRect);
    CGContextSetShadow(ctx, CGSizeMake(-1.0, 2.0), .5);
    
    [image drawInRect:imageRect];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return result;
}

-(UIImage *)drawTabBarOverSourceWithBlend:(CGBlendMode)blendMode{
    UIGraphicsBeginImageContext(CGSizeMake(60,60));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, 60);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CGContextDrawImage(ctx, CGRectMake(0, 0, 60.0, 60.0), [[self sourceImage] CGImage]);
    
    [[self tabBarImage] drawInRect:CGRectMake(0, 0, 60, 60) blendMode:blendMode alpha:1.0];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
