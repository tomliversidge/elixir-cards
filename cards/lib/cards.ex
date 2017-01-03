defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """
@type card :: %{suit: String.t, value: String.t}
@type deck :: list(card)
@type hand :: list(card)
@values ["Ace", "Two", "Three", "Four", "Five"]
@suits ["Spades", "Clubs", "Hearts", "Diamonds"]

defmacro is_valid_card(suit, value) do
  quote do
    unquote(suit) in @suits and unquote(value) in @values
  end
end

defp is_valid_card(card) do
  card[:suit] in @suits && card[:value] in @values
end

  @doc """
    Returns a list of Cards representing a deck of playing cards

  ## Examples

      iex> Cards.create_deck
      [%{suit: "Spades", value: "Ace"}, %{suit: "Spades", value: "Two"},
      %{suit: "Spades", value: "Three"}, %{suit: "Spades", value: "Four"},
      %{suit: "Spades", value: "Five"}, %{suit: "Clubs", value: "Ace"},
      %{suit: "Clubs", value: "Two"}, %{suit: "Clubs", value: "Three"},
      %{suit: "Clubs", value: "Four"}, %{suit: "Clubs", value: "Five"},
      %{suit: "Hearts", value: "Ace"}, %{suit: "Hearts", value: "Two"},
      %{suit: "Hearts", value: "Three"}, %{suit: "Hearts", value: "Four"},
      %{suit: "Hearts", value: "Five"}, %{suit: "Diamonds", value: "Ace"},
      %{suit: "Diamonds", value: "Two"}, %{suit: "Diamonds", value: "Three"},
      %{suit: "Diamonds", value: "Four"}, %{suit: "Diamonds", value: "Five"}]
"""
  @spec create_deck() :: deck
  def create_deck do
    for suit <- @suits, value <- @values do
      create_card(suit, value)
    end
  end

  @spec create_card(String.t, String.t) :: card
  def create_card(suit, value) when is_valid_card(suit, value) do
    %{suit: suit, value: value}
  end

  @doc """
  Gets a description of a card

  ## Examples

      iex> card = Cards.create_card("Spades", "Ace")
      iex> Cards.card_description(card)
      "Ace of Spades"
  """
  @spec card_description(card) :: String.t
  def card_description(card) do
    "#{card.value} of #{card.suit}"
  end

  @doc """
    Shuffles the deck of cards

  ## Examples

      iex> deck = [create_card("Spades", "Ace"),
      create_card("Spades", "Two"),
      create_card("Spades", "Three")]
      iex> Cards.shuffle(deck)
      [%{suit: "Spades", value: "Ace"},
      %{suit: "Spades", value: "Three"},
      %{suit: "Spades", value: "Two"}]

  """
  @spec shuffle(deck) :: deck
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines if the deck contains the card

  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, %{suit: "Spades", value: "Ace"})
      true
      iex> Cards.contains?(deck, %{suit: "Spades", value: "Ten"})
      false
  """
  @spec contains?(deck, card) :: boolean()
  def contains?(deck, card) do
    if is_valid_card(card) do
       Enum.member?(deck, card)
     else
       false
     end
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be dealt

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, _} = Cards.deal(deck, 1)
      iex> hand
      [%{suit: "Spades", value: "Ace"}]

  """
  @spec deal(deck, integer) :: {hand, deck}
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
    Saves the deck to the specified file
  """
  @spec save(deck, String.t) :: atom
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @doc """
    Loads the deck of cards from the specified file
  """
  @spec load(String.t) :: deck | String.t
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _} -> "That file does not exist"
    end
  end

  @doc """
    Helper method for creating, shuffling and dealing a deck of cards.
    `hand_size` determines the number of cards to deal.
    Returns a tuple where the first element is the hand and the
    second element is the remaining deck

  ## Examples

      iex> Cards.create_hand(2)
      {[%{suit: "Diamonds", value: "Four"}, %{suit: "Diamonds", value: "Two"}],
      [%{suit: "Spades", value: "Ace"}, %{suit: "Hearts", value: "Five"},
      %{suit: "Spades", value: "Five"}, %{suit: "Clubs", value: "Four"},
      %{suit: "Clubs", value: "Two"}, %{suit: "Hearts", value: "Ace"},
      %{suit: "Spades", value: "Three"}, %{suit: "Diamonds", value: "Ace"},
      %{suit: "Hearts", value: "Four"}, %{suit: "Clubs", value: "Five"},
      %{suit: "Diamonds", value: "Three"}, %{suit: "Clubs", value: "Ace"},
      %{suit: "Spades", value: "Two"}, %{suit: "Clubs", value: "Three"},
      %{suit: "Hearts", value: "Three"}, %{suit: "Diamonds", value: "Five"},
      %{suit: "Hearts", value: "Two"}, %{suit: "Spades", value: "Four"}]}
  """
  @spec create_hand(integer) :: {hand, deck}
  def create_hand(hand_size) do
    create_deck
    |> shuffle
    |> deal(hand_size)
  end
end
