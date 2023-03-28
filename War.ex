defmodule War do
  @moduledoc """
    this code plays out the card game war
  """

  @doc """
    Each function has its own documentation but in short:
    the game recursively calls itself until one player is out of card
  """
  def deal(shuf) do
    #starts the game and deals the deck to hand1 and hand2
    #calls the game part and changes the 14s back to 1s
    {hand1, hand2} = dealing(oneToFourteen(shuf))
    fourteenToOne(win(hand1,hand2))
  end

  def dealing(array) do
    #breaks the list into 2 lists for each player
    #adds cards to each player in alternating fashion by comparing the size of the length
    #returns the tuple with both decks
    {list1, list2} = Enum.reduce_while(array, {[], []}, fn x, {list1, list2} ->
    case length(list1) == length(list2) do
      true -> {:cont, {[x | list1], list2}}
      false -> {:cont, {list1, [x | list2]}}
    end
  end)
  {(list1), (list2)}
  end

  def oneToFourteen(list) do
    #changes all the ones to 14 to make it easier to compare in game
    Enum.map(list, fn x -> if x == 1, do: 14, else: x end)
  end

  def fourteenToOne(list) do
    #changes all the 14s to one
    Enum.map(list, fn x -> if x == 14, do: 1, else: x end)
  end

  #recursively calls itself until one player runs out of cards
  #returns the non-empty hand
  def win([], hand2), do: hand2
  def win(hand1, []), do: hand1
  def win(hand1, hand2) do
    {l1, l2} = turn(hand1, hand2) #calls turn to change each players hand
    win(l1, l2) #calls itself recursively
  end

  def turn([h1|t1], [h2|t2]) do
    #checks who won the battle and adds cards to the winner
    #calls warBattle if war occurs
    if (h1 > h2) do
      {t1 ++ [h1, h2], t2}
    else if (h2 > h1) do
      {t1, t2 ++ [h2,h1]}
    else
      warBattle([h1]++t1,[h2]++t2, [])
    end
    end
  end

  #Stays within warBattle until war has ended

  #checks if either player has run out of cards in the middle of war and then
  #returns both hands with the sorted war cards added to the winners hand
  def warBattle([],hand2, holder), do: {[], hand2 ++ Enum.sort(holder, :desc)}
  def warBattle(hand1,[], holder), do: {hand1 ++ Enum.sort(holder, :desc), []}

  #checks for edge cases when the player does not have enough cards to complete a war, so remove cards from both players until one is empty
  def warBattle(hand1, hand2, holder) when (length(hand2) == 2 or length(hand1) == 2) and length(holder)==0, do: warBattle(tl(tl(hand1)), tl(tl(hand2)), holder ++ [hd(hand1)] ++ [hd(hand2)] ++ [hd(tl(hand1))] ++ [hd(tl(hand2))])
  def warBattle(hand1, hand2, holder) when (length(hand1) < 3 or length(hand2) < 3) and length(holder)==0, do: warBattle(tl(hand1), tl(hand2), holder ++ [hd(hand1)] ++ [hd(hand2)])

  #actually plays the war part of the game
  #holder represents all the cards used in the war
  #adds first cards involved in war to holder and keeps adding to holder until war over
  #then adds golder cards to winner
  def warBattle([h1 | t1], [h2 | t2], holder) do
    cards = Enum.sort(holder ++ [h1] ++ [h2], :desc)
    if (h1 == h2) do
      warBattle(tl(t1),tl(t2),Enum.sort(cards ++ [hd(t1)] ++ [hd(t2)], :desc))
    else if (h1 > h2) do
      {t1 ++ cards, t2}
    else
      {t1, t2 ++ cards}
    end
    end
  end
end
