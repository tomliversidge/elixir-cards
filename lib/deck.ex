defmodule Deck do
  import Card
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """
@type card :: %Card{}
@type deck :: list(card)
@type hand :: list(card)

  @doc """
    Returns a list of Cards representing a deck of playing cards

  ## Examples

      iex> Deck.create
      [%Card{suit: :Spades, value: "Ace"}, %Card{suit: :Spades, value: "Two"},
      %Card{suit: :Spades, value: "Three"}, %Card{suit: :Spades, value: "Four"},
      %Card{suit: :Spades, value: "Five"}, %Card{suit: :Clubs, value: "Ace"},
      %Card{suit: :Clubs, value: "Two"}, %Card{suit: :Clubs, value: "Three"},
      %Card{suit: :Clubs, value: "Four"}, %Card{suit: :Clubs, value: "Five"},
      %Card{suit: :Hearts, value: "Ace"}, %Card{suit: :Hearts, value: "Two"},
      %Card{suit: :Hearts, value: "Three"}, %Card{suit: :Hearts, value: "Four"},
      %Card{suit: :Hearts, value: "Five"}, %Card{suit: :Diamonds, value: "Ace"},
      %Card{suit: :Diamonds, value: "Two"}, %Card{suit: :Diamonds, value: "Three"},
      %Card{suit: :Diamonds, value: "Four"}, %Card{suit: :Diamonds, value: "Five"}]
"""
  @spec create() :: deck
  def create do
    for suit <- Card.suits, value <- Card.values do
      Card.create(value, suit)
    end
  end

  @doc """
    Shuffles the deck of cards

  ## Examples

      iex> deck = Deck.create
      iex> Deck.shuffle(deck)
      [%Card{suit: :Hearts, value: "Five"}, %Card{suit: :Clubs, value: "Two"},
       %Card{suit: :Spades, value: "Three"}, %Card{suit: :Spades, value: "Two"},
       %Card{suit: :Diamonds, value: "Two"}, %Card{suit: :Clubs, value: "Ace"},
       %Card{suit: :Clubs, value: "Three"}, %Card{suit: :Diamonds, value: "Three"},
       %Card{suit: :Hearts, value: "Two"}, %Card{suit: :Diamonds, value: "Five"},
       %Card{suit: :Hearts, value: "Four"}, %Card{suit: :Hearts, value: "Three"},
       %Card{suit: :Diamonds, value: "Ace"}, %Card{suit: :Spades, value: "Four"},
       %Card{suit: :Clubs, value: "Five"}, %Card{suit: :Diamonds, value: "Four"},
       %Card{suit: :Hearts, value: "Ace"}, %Card{suit: :Clubs, value: "Four"},
       %Card{suit: :Spades, value: "Five"}, %Card{suit: :Spades, value: "Ace"}]
  """
  @spec shuffle(deck) :: deck
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines if the deck contains the card

  ## Examples

      iex> deck = Deck.create
      iex> Deck.contains?(deck, %Card{suit: :Spades, value: "Ace"})
      true
      iex> Deck.contains?(deck, %Card{suit: :Spades, value: "Fifty"})
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

      iex> deck = Deck.create
      iex> {hand, _} = Deck.deal(deck, 1)
      iex> hand
      [%Card{suit: :Spades, value: "Ace"}]

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

      iex> Deck.create_hand(2)
      {[%Card{suit: :Hearts, value: "Two"}, %Card{suit: :Diamonds, value: "Four"}],
       [%Card{suit: :Clubs, value: "Two"}, %Card{suit: :Hearts, value: "Four"},
        %Card{suit: :Clubs, value: "Ace"}, %Card{suit: :Spades, value: "Four"},
        %Card{suit: :Clubs, value: "Five"}, %Card{suit: :Spades, value: "Two"},
        %Card{suit: :Hearts, value: "Ace"}, %Card{suit: :Spades, value: "Three"},
        %Card{suit: :Spades, value: "Ace"}, %Card{suit: :Hearts, value: "Three"},
        %Card{suit: :Diamonds, value: "Ace"}, %Card{suit: :Hearts, value: "Five"},
        %Card{suit: :Diamonds, value: "Five"}, %Card{suit: :Clubs, value: "Four"},
        %Card{suit: :Clubs, value: "Three"}, %Card{suit: :Diamonds, value: "Three"},
        %Card{suit: :Spades, value: "Five"}, %Card{suit: :Diamonds, value: "Two"}]}
  """
  @spec create_hand(integer) :: {hand, deck}
  def create_hand(hand_size) do
    create
    |> shuffle
    |> deal(hand_size)
  end
end
