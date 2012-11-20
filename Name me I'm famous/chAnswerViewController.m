//
//  chAnswerViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chAnswerViewController.h"
#import "chQuestionAnswerViewController.h"
#import "nmifCelebrity.h"

@interface chAnswerViewController ()

@end

@implementation chAnswerViewController

@synthesize question = _question;
@synthesize lblQuestion = _lblQuestion;

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
    self.lblQuestion.text = [self.question question];
}

- (void)viewDidUnload
{
    [self setLblQuestion:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onBtnYesPressed:(id)sender {
    [self performSegueWithIdentifier:@"answerYes" sender:self];
}
- (IBAction)onBtnNoPressed:(id)sender {
    [self performSegueWithIdentifier:@"answerNo" sender:self];
}

- (IBAction)onBtnDontKnowPressed:(id)sender {
    [self performSegueWithIdentifier:@"answerDontKnow" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[chQuestionAnswerViewController class]] == YES) {
        chQuestionAnswerViewController* qavc = segue.destinationViewController;
        nmifQuestion* question = [[nmifQuestion alloc] initWithQuestion:self.lblQuestion.text];
        
        if ([segue.identifier isEqualToString:@"answerYes"]) {
            [question setAnswer:NSLocalizedString(@"YES", nil)];
        } else if ([segue.identifier isEqualToString:@"answerNo"]) {
            [question setAnswer:NSLocalizedString(@"NO", nil)];
        } else if ([segue.identifier isEqualToString:@"answerDontKnow"]) {
            [question setAnswer:NSLocalizedString(@"IDONTKNOW", nil)];
        }   
        
        [qavc setQuestion:question];
        [[nmifCelebrity sharedInstance] addQuestion:question];
        
        
    }
    
}
@end
