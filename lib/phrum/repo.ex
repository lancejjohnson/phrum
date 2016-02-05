defmodule Phrum.Repo do
  # use Ecto.Repo, otp_app: :phrum

  def all(Phrum.Scrum) do
    [
      %Phrum.Scrum{id: 1, date: "2016-02-02"},
      %Phrum.Scrum{id: 2, date: "2016-02-03"},
      %Phrum.Scrum{id: 3, date: "2016-02-04"},
      %Phrum.Scrum{id: 4, date: "2016-02-05"}
    ]
  end
end
