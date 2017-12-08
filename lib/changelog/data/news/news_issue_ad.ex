defmodule Changelog.NewsIssueAd do
  use Changelog.Data

  alias Changelog.{NewsIssue, NewsAd}

  schema "news_issue_ads" do
    field :position, :integer
    field :delete, :boolean, virtual: true

    belongs_to :ad, NewsAd, foreign_key: :ad_id
    belongs_to :issue, NewsIssue, foreign_key: :issue_id

    timestamps()
  end

  def changeset(news_issue_ad, params \\ %{}) do
    news_issue_ad
    |> cast(params, ~w(position ad_id issue_id delete))
    |> validate_required([:position])
    |> mark_for_deletion()
  end

  def by_position, do: from(q in __MODULE__, order_by: q.position)

  defp mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
