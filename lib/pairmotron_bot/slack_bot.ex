defmodule PairmotronBot.SlackBot do
  use Slack

  def child_spec(_opts) do
    slack_api_key = System.get_env("SLACK_PAIRMOTRON_BOT_USER_ACCESS_TOKEN")

    %{
      id: PairmotronBot.SlackBot,
      start: {Slack.Bot, :start_link, [PairmotronBot.SlackBot, [], slack_api_key]}
    }
  end

  def handle_connect(slack, state) do
    IO.puts("Successfully connected to Slack as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(
        message = %{
          type: "message",
          text: "<@" <> <<bot_id::bytes-size(9)>> <> "> " <> message_to_bot
        },
        %{me: %{id: bot_id}} = slack,
        state
      ) do
    bot_response = reply_to_message_directed_at_bot(message_to_bot, message, slack)
    send_message(bot_response, message.channel, slack)
    {:ok, state}
  end

  def handle_event(message = %{type: "message", text: text}, slack, state) do
    IO.inspect(message, label: "unmatched message")
    send_message("Stop all the downloadin", message.channel, slack)
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  defp reply_to_message_directed_at_bot("help", _, _), do: "Help Computer"
  defp reply_to_message_directed_at_bot("Help", _, _), do: "Help Computer"

  defp reply_to_message_directed_at_bot("Pair", message, slack),
    do: reply_to_message_directed_at_bot("pair", message, slack)

  defp reply_to_message_directed_at_bot("pair", message, slack) do
    human_users = get_human_users_in_channel(message, slack)
    groups = Accomplice.shuffled_group(human_users, %{minimum: 2, ideal: 2, maximum: 3})
    format_groups(groups)
  end

  defp reply_to_message_directed_at_bot(message_to_bot, _, _) do
    "What do you mean \"#{message_to_bot}\"?"
  end

  defp get_human_users_in_channel(message, slack) do
    current_channel = get_current_channel_or_dm(slack, message)

    case current_channel do
      %{is_im: true} = direct_message_channel ->
        []

      current_channel ->
        all_users = slack.users

        users_in_channel =
          current_channel[:members]
          |> Enum.map(fn member -> {member, all_users[member]} end)
          |> Enum.reject(fn {_, props} -> props[:is_bot] end)
          |> Enum.reject(fn {user_id, _} -> user_id == "USLACKBOT" end)
          |> Enum.map(fn {user_id, _} -> user_id end)
    end
  end

  defp get_current_channel_or_dm(slack, message) do
    channel_id = message[:channel]
    current_channel = slack.channels[channel_id] || slack.ims[channel_id]
  end

  defp format_groups([]), do: "I couldn't find anyone to pair :frowning:"

  defp format_groups(groups) do
    groups
    |> Enum.map(&format_single_group(&1))
    |> Enum.join("\n")
  end

  defp format_single_group(group) do
    group
    |> Enum.map(&"<@#{&1}>")
    |> Enum.join(", ")
  end
end
