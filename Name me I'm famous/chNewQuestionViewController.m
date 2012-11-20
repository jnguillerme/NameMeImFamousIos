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

@interface chNewQuestionViewController ()

@end

@implementation chNewQuestionViewController
@synthesize questionNumber = _questionNumber;
@synthesize lblQuestion = _lblQuestion;
@synthesize textFieldQuestion = _textFieldQuestion;
@synthesize question = _question;
@synthesize questionLabel = _questionLabel;

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
    self.lblQuestion.text = self.questionLabel;
}

- (void)viewDidUnload
{
    [self setLblQuestion:nil];
    [self setLblQuestion:nil];
    [self setTextFieldQuestion:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setQuestionNumberToNext {
    self.questionNumber++;
}

-(IBAction)textFieldQuestionReturn:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)backgroundTouched:(id)sender {

    [self.textFieldQuestion resignFirstResponder];
}

- (IBAction)onBtnAskQuestionPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = [NSString stringWithFormat:@"En attente de reponse de %@ ...", [[GMHelper sharedInstance] opponentName]];
  
    self.question = [[nmifQuestion alloc] initWithQuestion:self.textFieldQuestion.text];
    [[GMHelper sharedInstance] askQuestion:self.textFieldQuestion.text withDelegate:self];    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displayAnswer"]) {

        if ([segue.destinationViewController isKindOfClass:[chQuestionAnswerViewController class]] == YES) {
            chQuestionAnswerViewController* avc = segue.destinationViewController; 
            [avc setQuestion:self.question];
        }
    }
}

#pragma GMHelperDelegate
-(void)onAskQuestionSuccess:(NSString *)questionID
{
    [self.question setQuestionID:questionID];    
    	
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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Name me I'm famous" message:@"unexpected answer received" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

@end
