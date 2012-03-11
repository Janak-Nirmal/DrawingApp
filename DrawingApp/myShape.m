//
//  myShape.m
//  DrawingApp
//
//  Created by Lion User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Class to describe the shapes I use

#import "myShape.h"

@interface myShape() {
    
}
-(bool)pointOnLine:(CGPoint) point;
-(bool)pointContainedInCircle:(CGPoint) point;
@end

@implementation myShape
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize color = _color;
@synthesize selected = _selected;
@synthesize lineWidth = _lineWidth;
@synthesize isDashed = _isDashed;
@synthesize shape = _shape;


#pragma mark - Init codes
-(id)init {
    self = [super init];
    if(self) {
        _selected = false;
    }
    return self;
}


-(id)initCopy:(myShape *)input {
    self = [[myShape alloc] init];
    
    if(self) {
        _startPoint.x = input.startPoint.x;
        _startPoint.y = input.startPoint.y;
        _endPoint.x = input.endPoint.x;
        _endPoint.y = input.endPoint.y;
        _color = input.color;
        _selected = input.selected;
        _lineWidth = input.lineWidth;
        _shape = input.shape;
        _isDashed = input.isDashed;        
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    myShape *c = [[myShape alloc] initCopy:self];
    if(c) {
        return c;
    }
    return c;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [[myShape alloc] init];
    if(self) {
        _startPoint = [aDecoder decodeCGPointForKey:@"startPoint"];
        _endPoint = [aDecoder decodeCGPointForKey:@"_endPoint"];
        _color = [aDecoder decodeIntegerForKey:@"color"];
        _selected = [aDecoder decodeBoolForKey:@"selected"];
        _isDashed = [aDecoder decodeBoolForKey:@"isDashed"];
        _lineWidth = [aDecoder decodeIntForKey:@"lineWidth"];
        _shape = [aDecoder decodeIntForKey:@"shape"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeCGPoint:_startPoint forKey:@"startPoint"];
    [aCoder encodeCGPoint:_endPoint forKey:@"endPoint"];
    [aCoder encodeInteger:_color  forKey:@"color"];
    [aCoder encodeBool:_selected forKey:@"selected"];
    [aCoder encodeBool:_isDashed forKey:@"isDashed"];
    [aCoder encodeInt:_lineWidth forKey:@"lineWidth"];
    [aCoder encodeInt:_shape forKey:@"shape"];
}

#pragma mark - Select Shapes

-(bool)pointContainedInShape:(CGPoint) point {
    if(_shape == 0) {    // Line
        return [self pointOnLine:point];
    }
    else if(_shape == 1) {   // Rectangle
        CGRect rectangle = CGRectMake(_startPoint.x,
                                      _startPoint.y,
                                      _endPoint.x - _startPoint.x,
                                      _endPoint.y - _startPoint.y);
        
        return CGRectContainsPoint(rectangle, point);
    }
    else if(_shape == 2) {   // Circle
        return [self pointContainedInCircle:point];
    }
    else {
        NSLog(@"Error! Shouldn't be here!");
        return false;
    }
}

-(bool)pointOnLine:(CGPoint) point {
    float dx, dy;
    dx = _endPoint.x - _startPoint.x;
    dx = dx < 0 ? (dx * -1.0f) : dx;
    dy = _endPoint.y - _startPoint.y;
    dy = dx < 0 ? (dx * -1.0f) : dy;
    
    // If on/near line
    if(_startPoint.x <= _endPoint.x) {
        if((point.x < _startPoint.x) || (point.x > _endPoint.x)) {
            return false;
        }
    }
    
    if(_startPoint.x >= _endPoint.x) {
        if((point.x > _startPoint.x) || (point.x < _endPoint.x)) {
            return false;
        }
    }
    
    if(_startPoint.y <= _endPoint.y) {
        if((point.y < _startPoint.y) || (point.y > _endPoint.y)) {
            return false;
        }
    }
    
    if(_startPoint.y >= _endPoint.y) {
        if((point.y > _startPoint.y) || (point.y < _endPoint.y)) {
            return false;
        }
    }
        
    
    // Calculating slope
    float m1, m2, diff;
    m1 = (point.y - _startPoint.y)/(point.x - _startPoint.x);
    m2 = (_endPoint.y - _startPoint.y)/(_endPoint.x - _startPoint.x);
    if(dx <= dy) {
        m1 = 1.0f/m1;
        m2 = 1.0f/m2;
    }
    
    diff = m2 - m1;
    diff = diff < 0 ? (diff * -1.0f) : diff;    // Taking the abs value
    //NSLog(@"diff = %f",diff);
    
    if(diff <= 0.25f)
        return true;
    else
        return false;
}

-(bool)pointContainedInCircle:(CGPoint) point {
    float r0, r, dx0, dy0, dx, dy;
    dx0 = _endPoint.x - _startPoint.x;
    dy0 = _endPoint.y - _startPoint.y;
    dx = point.x - _startPoint.x;
    dy = point.y - _startPoint.y;
    
    r0 = sqrtf(dx0*dx0 + dy0*dy0);  // Radius of our shape
    r = sqrtf(dx*dx + dy*dy);   // Radius of touch to center
    
    r0 = r0 < 0.0f ? (r0 * -1.0f) : r0;
    r = r < 0.0f ? (r * -1.0f) : r;
    
    if(r <= r0)
        return true;
    else
        return false;
}


@end
