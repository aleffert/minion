//
//  ADLTool.m
//  Minion
//
//  Created by Akiva Leffert on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLTool.h"

@implementation ADLTool

@end


@interface ADLColorTool ()

@property (retain, nonatomic) UIColor* color;

@end

@implementation ADLColorTool

@synthesize color = _color;

+ (ADLColorTool*)colorToolWithColor:(UIColor*)color {
    ADLColorTool* result = [[ADLColorTool alloc] init];
    result.color = color;
    return result;
}

- (void)caseLineTool:(void (^)(ADLLineTool* tool))lineCase colorTool:(void(^)(ADLColorTool* tool))colorCase {
    colorCase(self);
}

@end

@implementation ADLLineTool

+ (ADLLineTool*)lineTool {
    return [[ADLLineTool alloc] init];
}


- (void)caseLineTool:(void (^)(ADLLineTool* tool))lineCase colorTool:(void(^)(ADLColorTool* tool))colorCase {
    lineCase(self);
}

@end
