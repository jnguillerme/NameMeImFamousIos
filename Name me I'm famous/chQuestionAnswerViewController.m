//
//  chQuestionAnswerViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chQuestionAnswerViewController.h"
#import "chWaitForQuestionViewController.h"
#import "MBProgressHUD.h"

@interface chQuestionAnswerViewController ()

@end

@implementation chQuestionAnswerViewController
@synthesize lblQuestion;
@synthesize lblAnswer;
@synthesize question = _question;

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
    self.lblQuestion.text = [NSString stringWithFormat:@"A la question %@ %@ a repondu ", self.question.question, [[GMHelper sharedInstance] opponentName]];

    NSString *answer;
    if ([self.question.answer compare:@"yes"] == NSOrderedSame) {
        answer = NSLocalizedString(@"YES", nil);
        self.lblAnswer.textColor = [UIColor greenColor];
    } else if ([self.question.answer compare:@"no"]  == NSOrderedSame ) {
        answer = NSLocalizedString(@"NO", nil);
        self.lblAnswer.textColor = [UIColor redColor];
    } else {
        answer = NSLocalizedString(@"IDONTKNOW", nil);
        self.lblAnswer.textColor = [UIColor orangeColor];
    }
    
    self.lblAnswer.text = answer;
}

- (void)viewDidUnload
{
    [self setLblQuestion:nil];
    [self setLblAnswer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onBtnSubmitCelebrityPressed:(id)sender {
    [self performSegueWithIdentifier:@"submitAnswer" sender:self];
}
- (IBAction)onBtnNextQuestionPressed:(id)sender {
//    [self performSegueWithIdentifier:@"askNextQuestion" sender:self];
    [[GMHelper sharedInstance] endTurn:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = [NSString stringWithFormat:@"preparation du nouveau tour..."];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"waitForQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chWaitForQuestionViewController class]] == YES) {
        }
    }
    
}

#pragma GMHelperDelegate
-(void) onNewTurn:(BOOL)myTurn
{
    if (!myTurn) {
        [self performSegueWithIdentifier:@"waitForQuestion" sender:self];
    }
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

@end
