//
//  ADClusterableAnnotation.m
//  ADClusterMapView
//
//  Created by Patrick Nollet on 27/06/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADBaseAnnotation.h"

@interface ADBaseAnnotation ()

@end

@implementation ADBaseAnnotation

- (id)initWithDictionary:(NSDictionary <NSString *, id> *)dictionary {
    
    NSDictionary * coordinateDictionary = [dictionary objectForKey:@"coordinates"];
    
    return [self initWithCoordinates:CLLocationCoordinate2DMake([[coordinateDictionary objectForKey:@"latitude"] doubleValue], [[coordinateDictionary objectForKey:@"longitude"] doubleValue])
                               title:[dictionary objectForKey:@"name"]
                            subtitle:nil];
}

- (id)initWithCoordinates:(CLLocationCoordinate2D)location title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
