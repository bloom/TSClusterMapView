//
//  TSDemoClusteredAnnotationView.m
//  ClusterDemo
//
//  Created by Adam Share on 1/13/15.
//  Copyright (c) 2015 Applidium. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "TSDemoClusteredAnnotationView.h"

@implementation TSDemoClusteredAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.image = [UIImage imageNamed:@"ClusterAnnotation"];
        self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        
        self.label.frame = self.frame;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.textColor = UIColorFromRGB(0x009fd6);
        self.label.center = CGPointMake(self.image.size.width/2, self.image.size.height*.43);
        self.centerOffset = CGPointMake(0, -self.frame.size.height/2);
        
        [self addSubview:self.label];
        
        self.canShowCallout = YES;
        
        [self clusteringAnimation];
    }
    return self;
}

- (void)clusteringAnimation {
    // Custom animations in here
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    if (annotation) {
        ADClusterAnnotation *clusterAnnotation = (ADClusterAnnotation *)annotation;
        NSUInteger count = clusterAnnotation.clusterCount;
        self.label.text = [self numberLabelText:count];
    }
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
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
