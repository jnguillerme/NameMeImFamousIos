//
//  nmifRulesViewController.m
//  Name me I'm famous
//
//  Created by Jino on 21/05/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifRulesViewController.h"
#import "nmifBackgroundLayer.h"

@interface nmifRulesViewController ()

@end

@implementation nmifRulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *resFiles = [NSArray arrayWithObjects:@"rules", @"packages", @"advices", nil];

    for(int i=0; i < 3;i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.origin.x + self.scrollView.frame.size.width * i;
        frame.origin.y = self.scrollView.frame.origin.y;
        frame.size = self.scrollView.frame.size;
        
        UITextView *subview = [[UITextView alloc] initWithFrame:frame];

        subview.backgroundColor = [UIColor clearColor];
        subview.font = [UIFont fontWithName:@"Calibri" size:12];
        subview.textColor = [UIColor whiteColor];
        
        NSError *err= nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[resFiles objectAtIndex:i] ofType:@"txt"];
        NSString * fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
        if (fileContent == nil) {
            NSLog(@"Error reading %@: %@", filePath, err);
        } else {
            subview.text = fileContent;
        }
        [self.scrollView addSubview:subview];
    }

    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];

    CAGradientLayer *bgLayerSV = [nmifBackgroundLayer blueGradient];
    bgLayerSV.frame = self.scrollView.bounds;
    [self.scrollView.layer insertSublayer:bgLayerSV atIndex:0];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * resFiles.count, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
- (IBAction)onPageChange:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // update the page when more than 50% of the previous / next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
@end
