//
//  TSClusterOperation.h
//  TapShield
//
//  Created by Adam Share on 7/14/14.
//  Copyright (c) 2014 TapShield, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSClusterMapView.h"

typedef void(^ClusterOperationCompletionBlock)(MKMapRect clusteredRect, BOOL finished, NSSet *poolAnnotationsToRemove);

@interface TSClusterOperation : NSOperation

@property (nonatomic, copy) ClusterOperationCompletionBlock finishedBlock;


+ (instancetype)mapView:(TSClusterMapView *)mapView rect:(MKMapRect)rect rootCluster:(ADMapCluster *)rootCluster showNumberOfClusters:(NSUInteger)numberOfClusters clusterAnnotations:(NSSet <ADClusterAnnotation *> *)clusterAnnotations completion:(ClusterOperationCompletionBlock)completion;

+ (instancetype)mapView:(TSClusterMapView *)mapView splitCluster:(ADMapCluster *)splitCluster clusterAnnotationsPool:(NSSet <ADClusterAnnotation *> *)clusterAnnotations;

+ (NSDictionary <NSValue *, NSMutableArray <id<MKAnnotation>> *>*)groupAnnotationsByLocationValue:(NSSet <id<MKAnnotation>>*)annotations;

@end
