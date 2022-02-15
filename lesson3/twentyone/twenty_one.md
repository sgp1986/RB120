Follow our normal OOP approach
1. write a description of the problem/game and extract major nouns and verbs
2. make an initial guess as organizing verbs into nouns and do a spike to explore
3. model thoughts into CRC cards

1. decribe the game
twenty one is a card game using 52 cards with 4 suits (13 each). number cards are the value of the number, face cards are 10, aces are 1 or 11. the dealer deals two cards to each player (dealer included), the player will either hit and add cards, or stay with the score they have. closest to 21 without going over wins. dealer stops hitting at 17

LS description
Twenty-One is a card game consisting of a dealer and a player, where the participants try to get as close to 21 as possible without going over.

Here is an overview of the game:
- Both participants are initially dealt 2 cards from a 52-card deck.
- The player takes the first turn, and can "hit" or "stay".
- If the player busts, he loses. If he stays, it's the dealer's turn.
- The dealer must hit until his cards add up to at least 17.
- If he busts, the player wins. If both player and dealer stays, then the highest total wins.
- If both totals are equal, then it's a tie, and nobody wins.

Nouns
player, dealer, card, deck, score, turn (game, total)
Verbs
deal, hit, stay, push, bust, win

2. Organize

Player < User / Dealer
User
  hit
  stay
  busted?
  total
Dealer
  deal
  hit
  stay
  busted?
  total
Deck
  deal
Game
  start

Spike
