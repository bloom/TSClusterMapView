//
//  TSDemoClusteredAnnotationView.h
//  ClusterDemo
//
//  Created by Adam Share on 1/13/15.
//  Copyright (c) 2015 Applidium. All rights reserved.
//


#import <TSClusterMapView/TSRefreshedAnnotationView.h>
#import <Quartz/Quartz.h>

@interface TSDemoClusteredAnnotationView : TSRefreshedAnnotationView

@property (strong, nonatomic) CATextLayer *textLayer;

@end
