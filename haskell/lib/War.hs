module War (deal) where

import Data.List

{--
this code plays out the card war game by taking a 52 int array and returning the end game array
--}

--this function gets called by the test file
--the function returns the end og game array recieved from the function win
deal :: [Int] -> [Int]
deal shuf = fourteenToOne(win(hand1, hand2))
    where
        (hand1,hand2) = dealing(oneToFourteen shuf)

--This function changes all the 1s to 14, otherwise returns the same int and returns the array
oneToFourteen :: [Int] -> [Int]
oneToFourteen = map (\x -> if x == 1 then 14 else x)

--This function changes all the 14s to 1, otherwise returns the same int and returns the array
--This function this used to revert the array back to normal before returning
fourteenToOne :: [Int] -> [Int]
fourteenToOne = map (\x -> if x == 14 then 1 else x)

--This function takes one array and returns a tuple with 2 arrays representing hand1 and hand2
dealing :: [Int] -> ([Int], [Int])
dealing array =
  let (list1, list2) = foldl (\(list1, list2) x ->
                                if length list1 == length list2
                                  then (x:list1, list2)
                                  else (list1, x:list2)) ([], []) array
  in (list1, list2)

--this function recursively calls turn until one of the hands run out of cards
--returns the hand that isn't empty
win :: ([Int], [Int]) -> [Int]
win ([],hand2) = hand2
win (hand1,[]) = hand1
win (hand1, hand2) = win nextTurn
    where nextTurn = turn(hand1, hand2) 

--this function is recursively called and changes each players deck based on whether hand1 or hand2 wins
--adds both top cards of each players deck to the winners hand
--if war occurs, the warBattle function is called
turn :: ([Int], [Int]) -> ([Int], [Int])
turn (h1:t1, h2:t2)
  | h1 > h2 = (t1 ++ [h1] ++ [h2], t2)
  | h2 > h1 = (t1, t2 ++ [h2] ++ [h1])
  | otherwise = warBattle (h1:t1, h2:t2, []) 

--this warfunction is called and recursively calls itself until war is over
--holder holds all the cards involved in the war
warBattle :: ([Int], [Int], [Int]) -> ([Int], [Int])
warBattle ([], hand2, holder) = ([], hand2 ++ reverse (sort holder))
warBattle (hand1, [], holder) = (hand1 ++ reverse (sort holder), [])

--this chunk checks for edge cases where the player runs out of cards mid-war
warBattle (hand1, hand2, holder) 
    | (length hand2 < 2 || length hand1 < 2) && length holder < 3 = 
    warBattle(tail hand1, tail hand2, holder ++ [head hand1] ++ [head hand2])

--this chunk of code checks if war has ended and adds the sorted holders array to the winners hand
warBattle (hand1h:hand1t, hand2h:hand2t, holder) = do
  let cards = reverse (sort (holder ++ [hand1h, hand2h]))
  if hand1h == hand2h then warBattle(tail hand1t, tail hand2t, reverse (sort (cards ++ [head hand1t, head hand2t])))
  else if hand1h > hand2h then (hand1t ++ cards, hand2t)
  else (hand1t, hand2t ++ cards)