defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings representing a deck of playing cards

  ## Examples

      iex> Cards.create_deck
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
      "Five of Spades", "Ace of Clubs", "Two of Clubs", "Three of Clubs",
      "Four of Clubs", "Five of Clubs", "Ace of Hearts", "Two of Hearts",
      "Three of Hearts", "Four of Hearts", "Five of Hearts", "Ace of Diamonds",
      "Two of Diamonds", "Three of Diamonds", "Four of Diamonds", "Five of Diamonds"]
  """
  @spec create_deck() :: list
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
    Shuffles the deck of cards

  ## Examples

      iex> deck = ["Ace of Spades", "Two of Spades", "Three of Spades"]
      iex> Cards.shuffle(deck)
      ["Two of Spades", "Ace of Spades", "Three of Spades"]
  """
  @spec shuffle(list) :: list
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines if the deck contains the card

  ## Examples

      iex> deck = ["Ace of Spades", "Two of Spades", "Three of Spades"]
      iex> Cards.contains?(deck, "Ace of Spades")
      true
      iex> Cards.contains?(deck, "Three of Diamonds")
      false
  """
  @spec contains?(list, String.t) :: boolean()
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be dealt

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]

  """
  @spec deal(list, integer) :: {list, list}
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
    Saves the deck to the specified file
  """
  @spec save(list, String.t) :: atom
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @doc """
    Loads the deck of cards from the specified file
  """
  @spec load(String.t) :: list | String.t
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
  @spec create_hand(integer) :: {list, list}
  def create_hand(hand_size) do
    create_deck
    |> shuffle
    |> deal(hand_size)
  end
end
