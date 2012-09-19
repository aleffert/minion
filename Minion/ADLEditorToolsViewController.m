//
//  ADLEditorToolsViewController.m
//  Minion
//
//  Created by Akiva Leffert on 9/8/12.
//
//

#import "ADLEditorToolsViewController.h"

#import "ADLNotebookLibrary.h"
#import "ADLSwatchButton.h"
#import "ADLTool.h"

@interface ADLEditorToolsViewController ()

@property (strong, nonatomic) IBOutletCollection(ADLSwatchButton) NSArray* swatchButtons;
@property (strong, nonatomic, readwrite) ADLTool* activeTool;

@end

@implementation ADLEditorToolsViewController
@synthesize swatchButtons = _swatchButtons;

- (void)viewDidLoad {
    
    [self updateSwatchButtons];
    NSArray* swatchColors = [[ADLNotebookLibrary sharedLibrary] swatchColors];
    [self.swatchButtons enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
        ADLSwatchButton* button = object;
        button.color = [swatchColors objectAtIndex:index];
    }];
}

#pragma mark Tools

- (void)updateSwatchButtons {
    __block UIColor* activeToolColor = nil;
    [self.activeTool caseLineTool:^(ADLLineTool* lineTool) {
    } colorTool:^(ADLColorTool* colorTool) {
        activeToolColor = colorTool.color;
    }];
    for(ADLSwatchButton* button in self.swatchButtons) {
        button.selected = [button.color isEqual:activeToolColor];
    }
}

- (IBAction)takeColorFrom:(ADLSwatchButton*)sender {
    self.activeTool = [ADLColorTool colorToolWithColor:sender.color];
    [self updateSwatchButtons];
}

- (IBAction)useLineTool:(id)sender {
    self.activeTool = [ADLLineTool lineTool];
    [self updateSwatchButtons];
}

@end
