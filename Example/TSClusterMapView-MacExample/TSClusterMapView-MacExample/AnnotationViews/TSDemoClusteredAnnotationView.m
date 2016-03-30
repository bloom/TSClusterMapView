//
//  TSDemoClusteredAnnotationView.m
//  ClusterDemo
//
//  Created by Adam Share on 1/13/15.
//  Copyright (c) 2015 Applidium. All rights reserved.
//

#define NSColorFromRGB(rgbValue) [NSColor \
colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "TSDemoClusteredAnnotationView.h"

@implementation TSDemoClusteredAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [NSImage imageNamed:@"ClusterAnnotation"];
        self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        
        self.textLayer = [[CATextLayer alloc] init];
        self.textLayer.frame = self.frame;
//        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textLayer.font = (__bridge CFTypeRef _Nullable)([NSFont systemFontOfSize:10]);
        self.textLayer.foregroundColor = NSColorFromRGB(0x009fd6).CGColor;
        
//        [self.textField setFrameOrigin:NSMakePoint(
//                                            (NSWidth([parentView bounds]) - NSWidth([subview frame])) / 2,
//                                            (NSHeight([parentView bounds]) - NSHeight([subview frame])) / 2
//                                            )];
//        [self.textField setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
        
//        self.textField.center = CGPointMake(self.image.size.width/2, self.image.size.height*.43);
        self.centerOffset = CGPointMake(0, -self.frame.size.height/2);
        
        [self.layer addSublayer:self.textLayer];
        
        self.canShowCallout = YES;
        
        [self clusteringAnimation];
    }
    return self;
}

- (void)clusteringAnimation {
    
    ADClusterAnnotation *clusterAnnotation = (ADClusterAnnotation *)self.annotation;
    
    NSUInteger count = clusterAnnotation.clusterCount;
    self.textLayer.string = [self numberLabelText:count];
}

- (NSString *)numberLabelText:(float)count {
    
    if (!count) {
        return nil;
    }
    
    if (count > 1000) {
        float rounded;
        if (count < 10000) {
            rounded = ceilf(count/100)/10;
            return [NSString stringWithFormat:@"%.1fk", rounded];
        }
        else {
            rounded = roundf(count/1000);
            return [NSString stringWithFormat:@"%luk", (unsigned long)rounded];
        }
    }
    
    return [NSString stringWithFormat:@"%lu", (unsigned long)count];
}


@end
