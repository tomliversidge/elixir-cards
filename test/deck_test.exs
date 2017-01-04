defmodule DeckTest do
  use ExUnit.Case
  doctest Deck, except: [create_hand: 1, shuffle: 1]

  test "deal returns correct number of cards" do
    deck = Deck.create
    {hand, remaining} = Deck.deal(deck, 1)
    assert Enum.count(hand) == 1
    assert Enum.count(remaining) == length(deck) - 1
  end
end
