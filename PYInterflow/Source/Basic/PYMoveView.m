//
//  PYMoveView.m
//  PYInterflow
//
//  Created by wlpiaoyi on 2018/3/31.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYMoveView.h"


@implementation PYMoveView{
@private
    CGPoint _offsetPoint;
    CGPoint _transformPoint;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    _offsetPoint = [touch locationInView: self.superview];
    if (self.blockTouchBegin) _blockTouchBegin(_transformPoint, self);
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView: self.superview];
    CGPoint p = CGPointMake((point.x - _offsetPoint.x), (point.y - _offsetPoint.y));
    self.transform = CGAffineTransformTranslate(self.transform, p.x, p.y);
    CGPoint p2 = _transformPoint;
    p2.x += p.x;
    p2.y += p.y;
    _transformPoint = p2;
    _offsetPoint = point;
    if (self.blockTouchMoved) _blockTouchMoved(_transformPoint, self);
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _transformPoint = CGPointMake(0, 0);
    if (self.blockTouchEnded) _blockTouchEnded(_transformPoint, self);
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.blockTouchCancelled) _blockTouchCancelled(_transformPoint, self);
}
@end
