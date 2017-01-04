defmodule Card do
  @enforce_keys [:suit, :value]
  defstruct [:suit, :value]
  @values ["Ace", "Two", "Three", "Four", "Five"]

  @doc """
  List of supported values
  """
  def values, do: @values

  @suits [:Spades, :Clubs, :Hearts, :Diamonds]
  @doc """
  List of supported suits
  """
  def suits, do: @suits

  defp validate(%Card{value: value, suit: suit} = card) do
    cond do
      not suit in @suits -> "invalid suit. Valid suits are #{Enum.join(@suits, " ")}"
      not value in @values -> "invalid value. Valid values are #{Enum.join(@values, " ")}"
      true -> card
    end
  end

  @doc """
  Gets a description of a card

  ## Examples

      iex> Card.create("Ace", :Spades)
      %Card{value: "Ace", suit: :Spades}

      iex> Card.create("Hundred", :Spades)
      "invalid value. Valid values are Ace Two Three Four Five"

      iex> Card.create("Ace", :Flowers)
      "invalid suit. Valid suits are Spades Clubs Hearts Diamonds"

  """
  @spec create(String.t, atom) :: %Card{}
  def create(value, suit) do
     validate(%Card{value: value, suit: suit})
  end

  @doc """
  Gets a description of a card

  ## Examples

      iex> card = Card.create("Ace", :Spades)
      iex> Card.card_description(card)
      "Ace of Spades"
  """
  @spec card_description(%Card{}) :: String.t
  def card_description(%Card{} = card) do
    "#{card.value} of #{card.suit}"
  end
end
