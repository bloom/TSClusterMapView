//
//  ViewController.h
//  TSClusterMapView-MacExample
//
//  Created by Adam J Share on 3/30/16.
//  Copyright © 2016 Adam J Share. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TSClusterMapView.h"

@interface ViewController : NSViewController <TSClusterMapViewDelegate>

@property (weak) IBOutlet TSClusterMapView *mapView;
@property (strong, nonatomic) NSDate *startTime;


@property (strong, nonatomic) NSMutableArray *streetLightAnnotations;
@property (strong, nonatomic) NSMutableArray *bathroomAnnotations;

@property (strong, nonatomic) NSMutableArray *streetLightAnnotationsAdded;
@property (strong, nonatomic) NSMutableArray *bathroomAnnotationsAdded;

@property (weak) IBOutlet NSTextField *lightTextField;
@property (weak) IBOutlet NSTextField *bathroomTextField;
@property (weak) IBOutlet NSStepper *bathroomStepper;
@property (weak) IBOutlet NSStepper *lightStepper;

@end

