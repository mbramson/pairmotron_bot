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
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    send_message("I got a message!", message.channel, slack)
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
