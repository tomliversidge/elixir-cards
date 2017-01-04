defmodule DeckTest do
  use ExUnit.Case
  doctest Deck, except: [create_hand: 1, shuffle: 1]

  # test "deal returns correct number of cards" do
  #   deck = ["1", "2", "3"]
  #   {hand, remaining} = Deck.deal(deck, 1)
  #   assert Enum.count(hand) == 1
  #   assert Enum.count(remaining) == 2
  # end
end
