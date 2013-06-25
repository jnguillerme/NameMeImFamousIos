//
//  chNewQuestionViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chNewQuestionViewController.h"
#import "chQuestionAnswerViewController.h"
#import "MBProgressHUD.h"
#import "nmifBackgroundLayer.h"

@interface chNewQuestionViewController ()

@end

@implementation chNewQuestionViewController
@synthesize questionNumber = _questionNumber;
@synthesize lblQuestion = _lblQuestion;
@synthesize textFieldQuestion = _textFieldQuestion;
@synthesize question = _question;
@synthesize questionLabel = _questionLabel;

NSString * const K_QUESTION_KEY = @"NMIF.ASKQUESTIONVIEWID.QUESTION";
NSString * const K_QUESTION_ASKED_KEY = @"NMIF.ASKQUESTIONVIEWID.QUESTIONASKED";
NSString * const K_QUESTION_ID_KEY = @"NMIF.ASKQUESTIONVIEWID.QUESTIONID";


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
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //  opponent status / btn param position
    CGRect frame = self.btnParam.frame;
    CGFloat xPosition = self.view.bounds.origin.x + self.view.bounds.size.width - (self.btnParam.bounds.size.width);
    CGFloat yPosition = self.view.bounds.origin.y + self.view.bounds.size.height - (self.btnParam.bounds.size.height * 1.5);
    frame.origin = CGPointMake(xPosition, yPosition);
    self.btnParam.frame = frame;
    
    frame = self.lblOpponentStatus.frame;
    xPosition = frame.origin.x;
    yPosition = self.view.bounds.origin.y + self.view.bounds.size.height - (self.btnParam.bounds.size.height * 1.5) + frame.size.height / 2;
    frame.origin = CGPointMake(xPosition, yPosition);
    self.lblOpponentStatus.frame = frame;
    
    frame = self.addBanner.frame;
    xPosition = frame.origin.x;
    yPosition = self.btnParam.frame.origin.y - self.btnParam.frame.size.height/2 - frame.size.height;
    frame.origin = CGPointMake(xPosition, yPosition);
    self.addBanner.frame = frame;
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuAskQuestionTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"ASK_QUESTION", nil) withDescription:NSLocalizedString(@"ASK_QUESTION_DESCRIPTION", nil) andImage:@"askquestion.png" andAction:@selector(onAsk) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"SHOW_HISTORY", nil) withDescription:NSLocalizedString(@"SHOW_HISTORY_DESCRIPTION", nil)andImage:@"gameHistory.png" andAction:@selector(onShowQuestionHistory) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    
    [[GMHelper sharedInstance] saveGameInProgress:@"askQuestionViewID"];
}

- (void)viewDidUnload
{
    [self setLblQuestion:nil];
    [self setLblQuestion:nil];
    [self setTextFieldQuestion:nil];
    [self setLblOpponentStatus:nil];
    [self setTvMenu:nil];
    [self setBtnParam:nil];
    [self setAddBanner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];
    self.lblQuestion.text = self.questionLabel;    
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
    
    if (questionAsked != nil) {
        [self.textFieldQuestion setText:questionAsked];
    }

}
-(void) viewDidAppear:(BOOL)animated
{
    [[GMHelper sharedInstance] setDelegate:self];
    [[GMHelper sharedInstance] replayPendingEvents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    if ([MBProgressHUD HUDForView:self.view] != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
            
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromNewQuestion" sender:self];
        }    
    }
}

-(void) setQuestionNumberToNext {
    self.questionNumber++;
}

-(IBAction)textFieldQuestionReturn:(id)sender
{
    [sender resignFirstResponder];
}
/*- (IBAction)backgroundTouched:(id)sender {

    [self.textFieldQuestion resignFirstResponder];
}*/
- (IBAction)onQuestionAskedHistoryPressed:(id)sender {
    [self performSegueWithIdentifier:@"questionAskedHistory" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // clear local store for the view
    [[GMHelper sharedInstance] clearLocalDataForKey:K_QUESTION_ASKED_KEY];
    [[GMHelper sharedInstance] clearLocalDataForKey:K_QUESTION_KEY];
    [[GMHelper sharedInstance] clearLocalDataForKey:K_QUESTION_ID_KEY];
 
    if ([segue.identifier isEqualToString:@"displayAnswer"]) {
        if ([segue.destinationViewController isKindOfClass:[chQuestionAnswerViewController class]] == YES) {
            chQuestionAnswerViewController* avc = segue.destinationViewController; 
            [avc setQuestion:self.question];
        }
    } 
}
- (IBAction)onEditQuestionBegin:(id)sender {
    [[GMHelper sharedInstance] startTyping];
}

- (IBAction)onEditQuestionEnd:(id)sender {
    [[GMHelper sharedInstance] stopTyping];
    // store the question in local data for game resume purposes
    [[GMHelper sharedInstance] storeLocalData:self.textFieldQuestion.text forKey:K_QUESTION_KEY];
}
#pragma nmifMenuAskQuestionTableViewDelegate
- (void)onAsk {
    if (self.textFieldQuestion.text.length > 0 ) {
        [self.view endEditing:YES];
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_REPLY",nil), [[GMHelper sharedInstance] opponentName]];
    
        self.question = [[nmifQuestion alloc] initWithQuestion:self.textFieldQuestion.text];
        [[GMHelper sharedInstance] askQuestion:self.textFieldQuestion.text withDelegate:self];
    
        // store the fact that the question has been asked
        [[GMHelper sharedInstance] storeLocalData:@"1" forKey:K_QUESTION_ASKED_KEY];
        [[GMHelper sharedInstance] storeLocalData:self.textFieldQuestion.text forKey:K_QUESTION_KEY];

        // store the question in question history
        if (questionAsked == nil || [questionAsked length] == 0) {
            [[GMHelper sharedInstance] addQuestionToHistory:self.textFieldQuestion.text];
        }
    }
}
-(void) onShowQuestionHistory
{
    if (questionAsked != nil) {
        questionAsked = @"";
    }
    [self performSegueWithIdentifier:@"showQuestionsHistory" sender:self];
}

#pragma GMHelperDelegate
-(void)onAskQuestionSuccess:(NSString *)questionID
{
    [self.question setQuestionID:questionID];
    [[GMHelper sharedInstance] storeLocalData:questionID forKey:K_QUESTION_ID_KEY];
}
-(void)onAskQuestionError:(NSString *)error
{
    
}
-(void)onAnswer:(NSString *)answer
{

}

-(void) onQuestionAnswered:(NSString*) questionID withAnswer:(NSString*)answer
{
    // segue to a new screen where the question + answer are displayed    
    if ( [self.question.questionID compare:questionID] == NSOrderedSame ) {
        [self.question setAnswer:answer];    
        [self performSegueWithIdentifier:@"displayAnswer" sender:self];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APPLICATION_NAME", nil) message:NSLocalizedString(@"UNEXPECTED_ANSWER_RECEIVED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}
-(void) onOpponentStatusUpdated {
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma nmifQuestionChoiceDelegate
-(void) setQuestionAsked:(NSString *)question
{
    if (questionAsked == nil)  {
        questionAsked = [[NSString alloc] initWithString:question];
    } else {
        questionAsked = question;
    }
}

#pragma GMRestoreViewDelegate
- (void) restorePrivateData
{
   if ([[GMHelper sharedInstance] hasLocalDataForKey:K_QUESTION_KEY]) {
       questionAsked = [[NSString alloc] initWithString:[[GMHelper sharedInstance] localDataForKey:K_QUESTION_KEY]];
        
        if ([[GMHelper sharedInstance] hasLocalDataForKey:K_QUESTION_ASKED_KEY]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_REPLY",nil), [[GMHelper sharedInstance] opponentName]];
            
            self.question = [[nmifQuestion alloc] initWithQuestion:questionAsked];
            [self.question setQuestionID:[[GMHelper sharedInstance] localDataForKey:K_QUESTION_ID_KEY]];

            [[GMHelper sharedInstance] setDelegate:self];
        }
    }

}
@end
