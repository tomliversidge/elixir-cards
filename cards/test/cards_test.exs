defmodule CardsTest do
  use ExUnit.Case
  doctest Cards, except: [create_hand: 1, shuffle: 1]

  test "deal returns correct number of cards" do
    deck = ["1", "2", "3"]
    {hand, remaining} = Cards.deal(deck, 1)
    assert Enum.count(hand) == 1
    assert Enum.count(remaining) == 2
  end

  describe "Cards.contains?" do

    test "returns true when card in deck" do
        deck = ["1", "2", "3"]
        assert Cards.contains?(deck, "1")
      end

      test "returns false when card not in deck" do
          deck = ["1", "2", "3"]
          refute Cards.contains?(deck, "123123")
      end
  end

end
