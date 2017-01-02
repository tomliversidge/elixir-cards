defmodule CardsTest do
  use ExUnit.Case
  doctest Cards, except: [create_hand: 1, shuffle: 1]

  test "deal returns correct number of cards" do
    deck = ["1", "2", "3"]
    {hand, remaining} = Cards.deal(deck, 1)
    assert Enum.count(hand) == 1
    assert Enum.count(remaining) == 2
  end

  describe "creating unsupported cards" do
    test "unsupports suit" do
      assert_raise FunctionClauseError, fn ->
        Cards.create_card("Wat", "Ace")
      end
    end
    test "unsupports value" do
      assert_raise FunctionClauseError, fn ->
        Cards.create_card("Ace", "Wat")
      end
    end
  end

  describe "Cards.contains?" do

    test "returns true when card in deck" do
        deck = [
          Cards.create_card("Spades", "Ace"),
          Cards.create_card("Spades", "Two"),
          Cards.create_card("Spades", "Three")
        ]

        assert Cards.contains?(deck, %{description: "Ace of Spades", suit: "Spades", value: "Ace"})
      end

      test "returns false when card not in deck" do
        deck = [
          Cards.create_card("Spades", "Ace"),
          Cards.create_card("Spades", "Two"),
          Cards.create_card("Spades", "Three")
        ]

        refute Cards.contains?(deck, Cards.create_card("Clubs", "Two"))
      end
  end

end
