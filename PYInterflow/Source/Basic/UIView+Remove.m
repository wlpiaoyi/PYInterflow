//
//  UIView+Remove.m
//  PYInterchange
//
//  Created by wlpiaoyi on 16/1/21.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Remove.h"
#import <objc/runtime.h>
#import "pyutilea.h"
//@interface UIViewHookRemoveImp : NSObject<UIViewHookDelegate>
//-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target;
//@end
//@implementation  UIViewHookRemoveImp
//-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target{
//    objc_removeAssociatedObjects(target);
//}
//@end

@interface PYViewRemoveParam : NSObject
/**
 是否可以移动
 */
@property (nonatomic) BOOL moveable;

//==>移动回调
@property (nonatomic, copy) BlockTouchView blockTouchBegin;
@property (nonatomic, copy) BlockTouchView blockTouchMove;
@property (nonatomic, copy) BlockTouchView blockTouchEnd;
///<
@property (nonatomic, strong) NSMutableDictionary * dicscrollenabled;
@property (nonatomic) CGPoint offsetPoint;
@property (nonatomic) CGPoint transformPoint;

@end

@implementation PYViewRemoveParam
-(instancetype) init{
    if(self = [super init]){
    }
    return self;
}
@end

static const void * UIViewRemovePointer = &UIViewRemovePointer;
@implementation UIView(Removeable)
-(PYViewRemoveParam *) params{
    PYViewRemoveParam * params = nil;
    @synchronized (self) {
        params = objc_getAssociatedObject(self, UIViewRemovePointer);
        if(params == nil){
            params = [PYViewRemoveParam new];
            objc_setAssociatedObject(self, UIViewRemovePointer, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return params;
}

-(BOOL) moveable{
    return [self params].moveable;
}
-(void) setMoveable:(BOOL)moveable{
    [self params].moveable = moveable;
    static dispatch_once_t predicate_view_remove;
    __unsafe_unretained typeof(self) unself = self;
    dispatch_once(&predicate_view_remove, ^{
        SEL selTouchBegin = @selector(touchesBegan:withEvent:);
        SEL selTouchMove = @selector(touchesMoved:withEvent:);
        SEL selTouchEnd = @selector(touchesEnded:withEvent:);
        SEL selTouchCancel = @selector(touchesCancelled:withEvent:);
        [unself hook:selTouchBegin];
        [unself hook:selTouchMove];
        [unself hook:selTouchEnd];
        [unself hook:selTouchCancel];
        if(IOS8_OR_LATER){
            [UIResponder hookWithMethodNames:nil];
        }
    });
}

-(BlockTouchView) blockTouchBegin{
    return [self params].blockTouchBegin;
}
-(void) setBlockTouchBegin:(BlockTouchView) block{
    [self params].blockTouchBegin = block;
}
-(BlockTouchView) blockTouchMove{
    return [self params].blockTouchMove;
}
-(void) setBlockTouchMove:(BlockTouchView) block{
    [self params].blockTouchMove = block;
}
-(BlockTouchView) blockTouchEnd{
    return [self params].blockTouchEnd;
}
-(void) setBlockTouchEnd:(BlockTouchView) block{
    [self params].blockTouchEnd = block;
}

-(void) hook:(SEL) orgSel{
    NSString *argArg = [NSString stringWithFormat:@"_hook%s",sel_getName(orgSel)];
    SEL hookSel = sel_getUid([argArg UTF8String]);
    if (![self respondsToSelector:hookSel]) {
        return;
    }
    Method orgm = class_getInstanceMethod([UIView class], orgSel);
    Method hookm = class_getInstanceMethod([UIView class], hookSel);
    method_exchangeImplementations(hookm, orgm);
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
}
-(void) _hooktouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *touchView = self;
    if (!self.moveable) {
        [touchView _hooktouchesBegan:touches withEvent:event];
        return;
    }
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView: touchView.superview];
    @try {
        BlockTouchView block = [touchView blockTouchBegin];
        if (block) {
            block([self params].transformPoint, touchView);
        }
    }
    @finally {
        [touchView setOffsetPoint:point];
    }
}
-(void) _hooktouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    UIView *touchView = self;
    if (!touchView.moveable) {
        [touchView _hooktouchesMoved:touches withEvent:event];
        return;
    }
    CGPoint point = [touch locationInView: touchView.superview];
    CGPoint offsetPoint = [touchView offsetPoint];
    CGPoint p = CGPointMake((point.x - offsetPoint.x), (point.y - offsetPoint.y));
    self.transform = CGAffineTransformTranslate(self.transform, p.x, p.y);
    CGPoint p2 = [self params].transformPoint;
    p2.x += p.x;
    p2.y += p.y;
    [self params].transformPoint = p2;
    [touchView setOffsetPoint:point];
    BlockTouchView block = [touchView blockTouchMove];
    if (block) {
        block([self params].transformPoint, touchView);
    }
}
-(void) _hooktouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *touchView = self;
    if (!touchView.moveable) {
        [touchView _hooktouchesEnded:touches withEvent:event];
        return;
    }
    @try {
        BlockTouchView block = [touchView blockTouchEnd];
        if (block) {
            block([self params].transformPoint, touchView);
        }
        [self params].transformPoint = CGPointMake(0, 0);
    }
    @finally {
    }
}
-(void) _hooktouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *touchView = self;
    if (!touchView.moveable) {
        [touchView _hooktouchesCancelled:touches withEvent:event];
        return;
    }
    [self params].transformPoint = CGPointMake(0, 0);
}

-(CGPoint) offsetPoint{
    return [self params].offsetPoint;
}
-(void) setOffsetPoint:(CGPoint) offsetPoint{
    [self params].offsetPoint = offsetPoint;
}

-(void) removeParams{
    objc_removeAssociatedObjects(self);
}

@end
