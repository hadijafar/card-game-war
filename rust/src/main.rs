#![allow(non_snake_case,non_camel_case_types,dead_code)]

// deals the shuf and calls the functions to return the winning player
fn deal(shuf: &[u8; 52]) -> [u8; 52] {
    let deck = aceHighest(shuf);
    let (mut player1, mut player2) = dealCards(&deck);
    let mut result = war_game(&mut player1, &mut player2);
    let finalDeck = changeAce(&mut result);
    finalDeck
}

//deals the list of cards and returns a tuple of player1 and player2
//puts the even indexed cards into player1 and odd indexed cards into player 2
//returns the players deck
fn dealCards(list: &[u8]) -> (Vec<u8>, Vec<u8>) {
    let player1: Vec<u8> = list.iter().enumerate().filter(|(i, _)| i % 2 == 0).map(|(_, &x)| x).rev().collect();
    let player2: Vec<u8> = list.iter().enumerate().filter(|(i, _)| i % 2 == 1).map(|(_, &x)| x).rev().collect();
    (player1, player2)
}

//converts the ace to 14 and returns the deck
fn aceHighest(shuf: &[u8; 52]) -> [u8; 52] {
    let mut deck = *shuf;
    for card in &mut deck {
        if *card == 1 {
            *card = 14;
        }
    }
    deck
}

//converts the 14 to ace and returns the deck
fn changeAce(list: &mut Vec<u8>) -> [u8; 52] {
    let mut result = [0; 52];
    
    for (i, card) in list.iter_mut().enumerate() {
        result[i] = if *card == 14 { 1 } else { *card };
    }
    
    result
}

//takes in the player1 and player2 deck and returns the winning deck
fn war_game(player1: &mut Vec<u8>, player2: &mut Vec<u8>) -> Vec<u8> {

    //creates a card holder for the cards won in war and appends them to the winning deck
    let mut round_cards: Vec<u8> = Vec::new();
    while player1.len() != 0 && player2.len() != 0 { 
        if player1[0] > player2[0] {
            player1.push(player1[0]);
            player1.push(player2[0]);
            player1.remove(0);
            player2.remove(0);
        }
        else if player1[0] < player2[0] {
            player2.push(player2[0]);
            player2.push(player1[0]);
            player1.remove(0);
            player2.remove(0);
        }

        //war begins
        else {
            while player1.len() > 2 && player2.len() > 2 && player1[0] == player2[0] {
                round_cards.push(player1[0]);
                round_cards.push(player2[0]);
                player1.remove(0);
                player2.remove(0);
                round_cards.push(player1[0]);
                round_cards.push(player2[0]);
                player1.remove(0);
                player2.remove(0);

                if player1[0] > player2[0]{
                    round_cards.push(player1[0]);
                    round_cards.push(player2[0]);
                    player1.remove(0);
                    player2.remove(0);
                    round_cards.sort_by(|a, b| b.cmp(a));
                    player1.append(&mut round_cards);
                    round_cards.clear();
                }

                else if player1[0] < player2[0]{
                    round_cards.push(player1[0]);
                    round_cards.push(player2[0]);
                    player1.remove(0);
                    player2.remove(0);
                    round_cards.sort_by(|a, b| b.cmp(a));
                    player2.append(&mut round_cards);
                    round_cards.clear();
                }
            }
            //if one of the players deck is empty break from the loop and add the holder cards to the winning deck
            if player1.len() == 0{
                round_cards.sort_by(|a, b| b.cmp(a));
                player2.append(&mut round_cards);
                round_cards.clear();
                break;
            }
            if player2.len() == 0{
                round_cards.sort_by(|a, b| b.cmp(a));
                player1.append(&mut round_cards);
                round_cards.clear();
                break;
            }

            // covers edge cases 
            if player1[0] != player2[0] && player1.len() < 3 || player2.len() < 3 {
                round_cards.push(player1[0]);
                round_cards.push(player2[0]);

                if player1[0]>player2[0]{
                    round_cards.sort_by(|a, b| b.cmp(a));
                    player1.append(&mut round_cards);
                    round_cards.clear();
                }

                if player1[0]<player2[0]{
                    round_cards.sort_by(|a, b| b.cmp(a));
                    player2.append(&mut round_cards);
                    round_cards.clear();
                }
                player1.remove(0);
                player2.remove(0);
            }

            if (player1.len() == 2 || player2.len() == 2) && player1[0] == player2[0] {
                for i in 0..2 {
                    round_cards.push(player1[0]);
                    round_cards.push(player2[0]);
                    player1.remove(0);
                    player2.remove(0);
                }
            }

            if (player1.len() == 1 || player2.len() == 1) && player1[0] == player2[0] {
                round_cards.push(player1[0]);
                round_cards.push(player2[0]);
                player1.remove(0);
                player2.remove(0);
            }

            if player1.len() == 0{
                round_cards.sort_by(|a, b| b.cmp(a));
                player2.append(&mut round_cards);
                round_cards.clear();
            }
            if player2.len() == 0{
                round_cards.sort_by(|a, b| b.cmp(a));
                player1.append(&mut round_cards);
                round_cards.clear();
            }
            
        }
    }

    //if player1 deck is empty return the player2 deck as a vector else return player 2
    if player1.len() == 0 {
        return player2.to_vec();
    }
    return player1.to_vec();
}

#[cfg(test)]
#[path = "tests.rs"]
mod tests;