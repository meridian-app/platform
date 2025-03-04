defmodule Platform.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :current_password, :string, virtual: true, redact: true
    field :confirmed_at, :utc_datetime

    belongs_to :organization, Platform.Organizations.Organization, foreign_key: :organization_id
    has_many :user_roles, Platform.Permissions.UserRole, foreign_key: :user_id
    has_many :roles, through: [:user_roles, :role]

    timestamps(type: :utc_datetime)
  end

  @doc """
  A users changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(users, attrs, opts \\ []) do
    users
    |> cast(attrs, [:name, :email, :password, :organization_id])
    |> validate_email(opts)
    |> validate_password(opts)
    |> validate_organization()
    |> foreign_key_constraint(:organization_id)
  end

  defp validate_organization(changeset) do
    changeset
    |> validate_required([:organization_id])
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Email must be a valid email address")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "Password must have at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "Password at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "Password must at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Platform.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A users changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(users, attrs, opts \\ []) do
    users
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "Email was not changed")
    end
  end

  @doc """
  A users changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(users, attrs, opts \\ []) do
    users
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "Password does not match")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(users) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(users, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no users or the users doesn't have a password, we call
  `Argon2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Platform.Accounts.Users{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    changeset = cast(changeset, %{current_password: password}, [:current_password])

    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "Invalid Password")
    end
  end
end
