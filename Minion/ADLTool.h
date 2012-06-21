//
//  ADLTool.h
//  Minion
//
//  Created by Akiva Leffert on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ADLColorToolType,
    ADLLineToolType
} ADLToolType;

@interface ADLTool : NSObject

@end


@interface ADLColorTool : ADLTool

+ (ADLColorTool*)colorToolWithColor:(UIColor*)color;

@property (readonly, retain, nonatomic) UIColor* color;

@end

@interface ADLLineTool : ADLTool

+ (ADLLineTool*)lineTool;

@end

@interface ADLTool (ADLCase)

- (void)caseLineTool:(void (^)(ADLLineTool* tool))lineCase colorTool:(void(^)(ADLColorTool* tool))colorCase;

@end