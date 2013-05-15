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
#import "nmifBackgroundLayer.h"


@interface chQuestionAnswerViewController ()

@end

@implementation chQuestionAnswerViewController
@synthesize lblQuestion;
@synthesize lblAnswer;
@synthesize question = _question;

NSString * const K_QUESTION_ANSWERVIEW_KEY = @"NMIF.QUESTIONANSWERVIEWID.QUESTION";
NSString * const K_ANSWER_ANSWERVIEW_KEY = @"NMIF.QUESTIONANSWERVIEWID.ANSWER";

-(void) setQuestion:(nmifQuestion *)question
{
    _question = question;
    [[GMHelper sharedInstance] storeLocalData:_question.question forKey:K_QUESTION_ANSWERVIEW_KEY];
    [[GMHelper sharedInstance] storeLocalData:_question.answer forKey:K_ANSWER_ANSWERVIEW_KEY];
}

-(nmifQuestion*) question
{
    if (_question == nil) {
        _question = [nmifQuestion alloc];
    }
    
    return _question;
}
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
    
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuQuestionAnswerTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"SUBMIT_CELEBRITY", nil) withDescription:NSLocalizedString(@"SUBMIT_CELEBRITY_DESCRIPTION", nil) andImage:@"submitCelebrity" andAction:@selector(onSubmitCelebrity) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"NEXT_QUESTION", nil) withDescription:NSLocalizedString(@"NEXT_QUESTION_DESCRIPTION", nil)andImage:@"nextTurn.png" andAction:@selector(onNextQuestion) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    
    [[GMHelper sharedInstance] saveGameInProgress:@"questionAnsweredViewID"];
}
- (void) viewWillAppear:(BOOL)animated
{
    self.lblQuestion.text = [NSString stringWithFormat:NSLocalizedString(@"ANSWER_PROVIDED_TO_QUESTION", nil), self.question.question, [[GMHelper sharedInstance] opponentName]];
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];

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

-(void) viewDidAppear:(BOOL)animated
{
    [[GMHelper sharedInstance] setDelegate:self];
    [[GMHelper sharedInstance] replayPendingEvents];
}

- (void)viewDidUnload
{
    [self setLblQuestion:nil];
    [self setLblAnswer:nil];
    [self setLblOpponentStatus:nil];
    [self setTvMenu:nil];
    [self setBtnParam:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   if ([MBProgressHUD HUDForView:self.view] != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
            
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromQuestionAnswer" sender:self];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"waitForQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chWaitForQuestionViewController class]] == YES) {
        }
    }
    
}
#pragma nmifMenuQuestionAnswerTableViewDelegate
- (void)onNextQuestion
{
    [[GMHelper sharedInstance] endTurn:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:@"preparation du nouveau tour..."];
}
-(void) onSubmitCelebrity
{
    [self performSegueWithIdentifier:@"submitCelebrityFromQuestionAnswer" sender:self];
}

#pragma GMHelperDelegate
-(void) onNewTurn:(BOOL)myTurn
{
    if (!myTurn) {
        [self performSegueWithIdentifier:@"waitForQuestion" sender:self];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"skipOpponentTurn" sender:self];        
    }
}

-(void) onOpponentDisconnected {
}
-(void) onOpponentStatusUpdated {
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma GMRestoreViewDelegate
- (void) restorePrivateData
{
    if ([[GMHelper sharedInstance] hasLocalDataForKey:K_QUESTION_ANSWERVIEW_KEY] && [[GMHelper sharedInstance]hasLocalDataForKey:K_ANSWER_ANSWERVIEW_KEY]) {
        _question = [[nmifQuestion alloc] initWithQuestion:[[GMHelper sharedInstance] localDataForKey:K_QUESTION_ANSWERVIEW_KEY]];
        _question.answer = [[GMHelper sharedInstance] localDataForKey:K_ANSWER_ANSWERVIEW_KEY];
    }
}
@end
