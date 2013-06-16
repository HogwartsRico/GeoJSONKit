//
//  GeoJSONLineString.m
//  GeoJSONKit
//
//  Created by zhang baocai on 6/15/13.
//  Copyright (c) 2013 igis.me. All rights reserved.
//

#import "GeoJSONLineString.h"
#import "GeoJSONPoint.h"
@implementation GeoJSONLineString

-(void)dealloc
{
    if (_lineStringPoints != nil) {
        [_lineStringPoints release];
        _lineStringPoints = nil;
    }
    [super dealloc];
}
-(id) initWithPoints:(NSArray*)points
{
   
    return [self initWithPoints:points bbox:nil crs:nil];
}
-(id) initWithPoints:(NSArray*)points bbox:(GeoJSONBBox*) bbox crs:(GeoJSONCRS*) crs
{
    if (self = [super initWithType:GeoJSONObjectType_Geom_LineString bBox:bbox crs:crs]) {
         _lineStringPoints = [points retain];
    }
    return self;
}
/*
 { "type": "LineString",
 "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
 }
 */
-(id) initWithJSON:(id)dictOrArray
{
    if (dictOrArray == nil ||  ![dictOrArray isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    GeoJSONBBox *bbox = [GeoJSONObject bboxFromJSON:dictOrArray];
    GeoJSONCRS * crs = [GeoJSONObject crsFromJSON:dictOrArray];
    NSDictionary * dictGeom = (NSDictionary *)dictOrArray;
    NSArray * array = [dictGeom objectForKey:@"coordinates"];
    NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[array count] ];
    for (NSArray * cArray in array) {
        CGPoint p = CGPointMake([[cArray objectAtIndex:0] doubleValue], [[cArray objectAtIndex:1] doubleValue]);
        NSValue * v = [NSValue valueWithCGPoint:p];
        [mArray addObject:v];

    }
    [self initWithPoints:mArray bbox:bbox crs:crs];
    [mArray release];
    return self;
}
-(NSInteger)numOfPoints
{
    return [_lineStringPoints count];
}
-(GeoJSONPoint*) pointAtIndex:(NSInteger) index
{
    if (index < [_lineStringPoints count]) {
        NSValue * v = [_lineStringPoints objectAtIndex:index];
        GeoJSONPoint *p = [[[GeoJSONPoint alloc] initWithX:v.CGPointValue.x y:v.CGPointValue.y] autorelease];
        return p;
    }
    return  nil;
}
@end