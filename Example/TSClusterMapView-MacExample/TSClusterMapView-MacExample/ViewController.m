//
//  ViewController.m
//  TSClusterMapView-MacExample
//
//  Created by Adam J Share on 3/30/16.
//  Copyright © 2016 Adam J Share. All rights reserved.
//

#import "ViewController.h"
#import "ADBaseAnnotation.h"
#import "TSBathroomAnnotation.h"
#import "TSStreetLightAnnotation.h"
#import "TSDemoClusteredAnnotationView.h"

static NSString * const CDStreetLightJsonFile = @"CDStreetlights";
static NSString * const kStreetLightAnnotationImage = @"StreetLightAnnotation";

static NSString * const CDToiletJsonFile = @"CDToilets";
static NSString * const kBathroomAnnotationImage = @"BathroomAnnotation";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.857617, 2.338820), MKCoordinateSpanMake(1.0, 1.0))];
    _mapView.clusterDiscrimination = 1.0;
    
    //    [_tabBar setSelectedItem:_bathroomTabBarItem];
    
    [self parseJsonData];
    
    //    [self refreshBadges];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kdTreeLoadingProgress:)
                                                 name:KDTreeClusteringProgress
                                               object:nil];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}



#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *view;
    
    if ([annotation isKindOfClass:[TSStreetLightAnnotation class]]) {
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([TSStreetLightAnnotation class])];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:NSStringFromClass([TSStreetLightAnnotation class])];
            view.image = [NSImage imageNamed:kStreetLightAnnotationImage];
            view.canShowCallout = YES;
            view.centerOffset = CGPointMake(view.centerOffset.x, -view.frame.size.height/2);
        }
    }
    else if ([annotation isKindOfClass:[TSBathroomAnnotation class]]) {
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([TSBathroomAnnotation class])];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:NSStringFromClass([TSBathroomAnnotation class])];
            view.image = [NSImage imageNamed:kBathroomAnnotationImage];
            view.canShowCallout = YES;
            view.centerOffset = CGPointMake(view.centerOffset.x, -view.frame.size.height/2);
        }
    }
    
    return view;
}


#pragma mark - ADClusterMapView Delegate

- (MKAnnotationView *)mapView:(TSClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
    
    TSDemoClusteredAnnotationView * view = (TSDemoClusteredAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    if (!view) {
        view = [[TSDemoClusteredAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    }
    
    return view;
}

- (void)mapView:(TSClusterMapView *)mapView willBeginBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree will begin mapping item count %lu", (unsigned long)annotations.count);
    
    _startTime = [NSDate date];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (annotations.count > 10000) {
                    [_buildProgress setHidden:NO];
                }
                else {
                    [_buildProgress setHidden:YES];
                }
    }];
}

- (void)mapView:(TSClusterMapView *)mapView didFinishBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree finished mapping item count %lu", (unsigned long)annotations.count);
    NSLog(@"Took %f seconds", -[_startTime timeIntervalSinceNow]);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_buildProgress setHidden:YES];
                _buildProgress.doubleValue = 0.0;
    }];
}

- (void)mapViewWillBeginClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation will begin");
}

- (void)mapViewDidCancelClusteringAnimation:(TSClusterMapView *)mapView {
    
    NSLog(@"Animation operation cancelled");
}

- (void)mapViewDidFinishClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation finished");
}

- (void)userWillPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map will pan from user interaction");
}

- (void)userDidPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map did pan from user interaction");
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldForceSplitClusterAnnotation:(ADClusterAnnotation *)clusterAnnotation {
    
    return YES;
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldRepositionAnnotations:(NSArray<ADClusterAnnotation *> *)annotations toAvoidClashAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    return YES;
}


#pragma mark - Steppers

- (IBAction)lightChange:(NSStepper *)stepper {
    
    if (stepper.integerValue > _streetLightAnnotationsAdded.count) {
        [self addNewStreetLight];
    }
    else if (stepper.integerValue >= 0){
        [self removeLastStreetLight];
    }
    stepper.maxValue = _streetLightAnnotations.count;
    stepper.integerValue = _streetLightAnnotationsAdded.count;
    self.lightTextField.stringValue = @(stepper.integerValue).stringValue;
}



- (IBAction)bathroomChange:(NSStepper *)stepper {
    
    if (stepper.integerValue > _bathroomAnnotationsAdded.count) {
        [self addNewBathroom];
    }
    else if (stepper.integerValue >= 0){
        [self removeLastBathroom];
    }
    stepper.maxValue = _bathroomAnnotations.count;
    stepper.integerValue = _bathroomAnnotationsAdded.count;
    self.bathroomTextField.stringValue = @(stepper.integerValue).stringValue;
}

- (void)addNewBathroom {
    
    if (_bathroomAnnotationsAdded.count >= _bathroomAnnotations.count) {
        return;
    }
    
    NSLog(@"Adding 1 %@", CDToiletJsonFile);
    
    TSBathroomAnnotation *annotation = [_bathroomAnnotations objectAtIndex:_bathroomAnnotationsAdded.count];
    [_bathroomAnnotationsAdded addObject:annotation];
    
    [_mapView addClusteredAnnotation:annotation];
}

- (void)addNewStreetLight {
    
    if (_streetLightAnnotationsAdded.count >= _streetLightAnnotations.count) {
        return;
    }
    
    NSLog(@"Adding 1 %@", CDStreetLightJsonFile);
    
    TSStreetLightAnnotation *annotation = [_streetLightAnnotations objectAtIndex:_streetLightAnnotationsAdded.count];
    [_streetLightAnnotationsAdded addObject:annotation];
    
    [_mapView addClusteredAnnotation:annotation];
}

- (void)removeLastBathroom {
    
    NSLog(@"Removing 1 %@", CDToiletJsonFile);
    
    TSBathroomAnnotation *annotation = [_bathroomAnnotationsAdded lastObject];
    [_bathroomAnnotationsAdded removeObject:annotation];
    [_mapView removeAnnotation:annotation];
}

- (void)removeLastStreetLight {
    
    NSLog(@"Removing 1 %@", CDStreetLightJsonFile);
    
    TSStreetLightAnnotation *annotation = [_streetLightAnnotationsAdded lastObject];
    [_streetLightAnnotationsAdded removeObject:annotation];
    [_mapView removeAnnotation:annotation];
}



- (IBAction)bufferChange:(NSSegmentedCell *)sender {
    
    switch (sender.selectedSegment + 1) {
            //        case 0:
            //            _mapView.clusterEdgeBufferSize = ADClusterBufferNone;
            //            break;
            
        case 1:
            _mapView.clusterEdgeBufferSize = ADClusterBufferSmall;
            break;
            
        case 2:
            _mapView.clusterEdgeBufferSize = ADClusterBufferMedium;
            break;
            
        case 3:
            _mapView.clusterEdgeBufferSize = ADClusterBufferLarge;
            break;
            
        default:
            break;
    }
}


#pragma mark - Controls

- (IBAction)addAllBathrooms:(id)sender {
    
    NSLog(@"Adding All %@", CDToiletJsonFile);
    
    [_mapView addClusteredAnnotations:_bathroomAnnotations];
    _bathroomAnnotationsAdded = [NSMutableArray arrayWithArray:_bathroomAnnotations];
    
    
    self.bathroomTextField.stringValue = @(_bathroomAnnotationsAdded.count).stringValue;
}

- (IBAction)addAllLights:(id)sender {
    NSLog(@"Adding All %@", CDStreetLightJsonFile);
    
    [_mapView addClusteredAnnotations:_streetLightAnnotations];
    _streetLightAnnotationsAdded = [NSMutableArray arrayWithArray:_streetLightAnnotations];
    
    self.lightTextField.stringValue = @(_streetLightAnnotationsAdded.count).stringValue;
}

- (IBAction)removeAllBathrooms:(id)sender {
    
    [_mapView removeAnnotations:_bathroomAnnotationsAdded];
    [_bathroomAnnotationsAdded removeAllObjects];
    
    NSLog(@"Removing All %@", CDToiletJsonFile);
    
    self.bathroomTextField.stringValue = @(_bathroomAnnotationsAdded.count).stringValue;
}


- (IBAction)removeAllLights:(id)sender {
    [_mapView removeAnnotations:_streetLightAnnotationsAdded];
    [_streetLightAnnotationsAdded removeAllObjects];
    
    NSLog(@"Removing All %@", CDStreetLightJsonFile);
    
    self.lightTextField.stringValue = @(_streetLightAnnotationsAdded.count).stringValue;
}


/*
 - (IBAction)sliderValueChanged:(id)sender {
 
 _mapView.clusterPreferredVisibleCount = roundf(_slider.value);
 _label.text = [NSString stringWithFormat:@"%lu", (unsigned long)_mapView.clusterPreferredVisibleCount];
 }
 
 */

- (void)parseJsonData {
    
    _streetLightAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    _bathroomAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    _streetLightAnnotationsAdded = [[NSMutableArray alloc] initWithCapacity:10];
    _bathroomAnnotationsAdded = [[NSMutableArray alloc] initWithCapacity:10];
    NSLog(@"Loading data…");
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CDStreetLightJsonFile ofType:@"json"]];
        
        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            TSStreetLightAnnotation * annotation = [[TSStreetLightAnnotation alloc] initWithDictionary:annotationDictionary];
            [_streetLightAnnotations addObject:annotation];
        }
        
        NSLog(@"Finished CDStreetLightJsonFile");
    }];
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CDToiletJsonFile ofType:@"json"]];
        
        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            TSBathroomAnnotation * annotation = [[TSBathroomAnnotation alloc] initWithDictionary:annotationDictionary];
            [_bathroomAnnotations addObject:annotation];
        }
        
        NSLog(@"Finished CDToiletJsonFile");
    }];
}


- (void)kdTreeLoadingProgress:(NSNotification *)notification {
    NSNumber *number = [notification object];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                _buildProgress.doubleValue = number.floatValue;
    }];
}

@end
