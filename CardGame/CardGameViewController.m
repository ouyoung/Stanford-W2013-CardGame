//
//  CardGameViewController.m
//  CardGame
//
//  Created by Vladimir on 21.03.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardsToOpenControl;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame* game;
@property (nonatomic) BOOL firstFlipMade;
@end

@implementation CardGameViewController


- (void) setFlipCount:(int)flipCount
{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat: @"Flips: %d", self.flipCount];
	NSLog(@"flips updated to %d", self.flipCount);
}

- (void) setCardButtons:(NSArray *)cardButtons
{
	_cardButtons = cardButtons;
	[self updateUI];
}

+ (UIImage*) cardBackImage
{
	return [UIImage imageNamed:@"cardback.png"];
}

- (void) updateUI
{
	for(UIButton* cardButton in self.cardButtons) {
		NSUInteger index = [self.cardButtons indexOfObject: cardButton];
		Card* card = [self.game cardAtIndex: index];
		
		[cardButton setTitle: [card contents] forState: UIControlStateSelected];
		[cardButton setTitle: [card contents] forState: UIControlStateSelected|UIControlStateDisabled];
		[cardButton setImage: card.isFaceUp?nil:[CardGameViewController cardBackImage]
					forState: UIControlStateNormal];
		cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
		cardButton.selected = card.faceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
	}
	
	self.scoreLabel.text = [NSString stringWithFormat: @"Score: %d", self.game.score];
	self.lastFlipResultLabel.text = [self.game lastFlipResult];
	self.cardsToOpenControl.enabled = !self.firstFlipMade;
}

- (CardMatchingGame*) game
{
	if (!_game) {
		Deck* deck = [[PlayingCardDeck alloc] init];
		_game = [[CardMatchingGame alloc] initWithCardCount: [self.cardButtons count] usingDeck: deck];
		self.firstFlipMade = NO;
	}
	return _game;
}

- (IBAction)flipCard:(UIButton *)sender {
	self.firstFlipMade = YES;
	NSUInteger index = [self.cardButtons indexOfObject: sender];
	[self.game flipCardAtIndex: index];
	self.flipCount++;	
	[self updateUI];
}

- (IBAction)deal:(UIButton *)sender {
	self.game = nil;
	[self updateUI];
}

- (IBAction)changedCardsToOpen:(UISegmentedControl *)sender {
	int cardsToOpen = self.cardsToOpenControl.selectedSegmentIndex == 0 ? 2 : 3;
	self.game.maxCardsToOpen = cardsToOpen;
}

@end
