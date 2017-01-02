defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """
@type card :: %{description: String.t, suit: String.t, value: String.t}
@type deck :: list(card)
@type hand :: list(card)
@values ["Ace", "Two", "Three", "Four", "Five"]
@suits ["Spades", "Clubs", "Hearts", "Diamonds"]

defmacro is_valid_card(suit, value) do
  quote do
    unquote(suit) in @suits and unquote(value) in @values
  end
end

  @doc """
    Returns a list of Cards representing a deck of playing cards

  ## Examples

      iex> Cards.create_deck
      [%{description: "Ace of Spades", suit: "Spades", value: "Ace"},
      %{description: "Two of Spades", suit: "Spades", value: "Two"},
      %{description: "Three of Spades", suit: "Spades", value: "Three"},
      %{description: "Four of Spades", suit: "Spades", value: "Four"},
      %{description: "Five of Spades", suit: "Spades", value: "Five"},
      %{description: "Ace of Clubs", suit: "Clubs", value: "Ace"},
      %{description: "Two of Clubs", suit: "Clubs", value: "Two"},
      %{description: "Three of Clubs", suit: "Clubs", value: "Three"},
      %{description: "Four of Clubs", suit: "Clubs", value: "Four"},
      %{description: "Five of Clubs", suit: "Clubs", value: "Five"},
      %{description: "Ace of Hearts", suit: "Hearts", value: "Ace"},
      %{description: "Two of Hearts", suit: "Hearts", value: "Two"},
      %{description: "Three of Hearts", suit: "Hearts", value: "Three"},
      %{description: "Four of Hearts", suit: "Hearts", value: "Four"},
      %{description: "Five of Hearts", suit: "Hearts", value: "Five"},
      %{description: "Ace of Diamonds", suit: "Diamonds", value: "Ace"},
      %{description: "Two of Diamonds", suit: "Diamonds", value: "Two"},
      %{description: "Three of Diamonds", suit: "Diamonds", value: "Three"},
      %{description: "Four of Diamonds", suit: "Diamonds", value: "Four"},
      %{description: "Five of Diamonds", suit: "Diamonds", value: "Five"}]
"""
  @spec create_deck() :: deck
  def create_deck do
    for suit <- @suits, value <- @values do
      create_card(suit, value)
    end
  end

  @spec create_card(String.t, String.t) :: card
  def create_card(suit, value) when is_valid_card(suit, value) do
    %{suit: suit, value: value, description: "#{value} of #{suit}"}
  end
  @doc """
    Shuffles the deck of cards

  ## Examples

      iex> deck = [create_card("Spades", "Ace"),
      create_card("Spades", "Two"),
      create_card("Spades", "Three")]
      iex> Cards.shuffle(deck)
      [%{description: "Ace of Spades", suit: "Spades", value: "Ace"},
      %{description: "Three of Spades", suit: "Spades", value: "Three"},
      %{description: "Two of Spades", suit: "Spades", value: "Two"}]

  """
  @spec shuffle(deck) :: deck
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines if the deck contains the card

  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, %{description: "Ace of Spades", suit: "Spades", value: "Ace"})
      true
      iex> Cards.contains?(deck, %{description: "Three of Diamonds"})
      false
  """
  @spec contains?(deck, card) :: boolean()
  def contains?(deck, card) do
       Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be dealt

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, _} = Cards.deal(deck, 1)
      iex> hand
      [%{description: "Ace of Spades", suit: "Spades", value: "Ace"}]

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
      {["Ace of Clubs", "Three of Spades"],
      ["Four of Clubs", "Four of Hearts", "Three of Diamonds", "Two of Diamonds",
      "Five of Spades", "Three of Clubs", "Two of Clubs", "Five of Hearts",
      "Four of Spades", "Two of Hearts", "Three of Hearts", "Four of Diamonds",
      "Two of Spades", "Ace of Spades", "Ace of Diamonds", "Five of Diamonds",
      "Ace of Hearts", "Five of Clubs"]}
  """
  @spec create_hand(integer) :: {hand, deck}
  def create_hand(hand_size) do
    create_deck
    |> shuffle
    |> deal(hand_size)
  end
end
