cask "nosleep" do
  version "1.2.0"
  sha256 "250b091f9899868aef8d7cffb280cb8c17f92e9fc50dc159c515596499cc4703"

  url "https://github.com/sergio-farfan/nosleep/releases/download/v#{version}/NoSleep-#{version}.dmg"
  name "NoSleep"
  desc "Menu bar toggle for caffeinate that prevents idle sleep"
  homepage "https://github.com/sergio-farfan/nosleep"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "NoSleep.app"

  # Quit before replacing the bundle, and drop the Start at Login item on
  # uninstall (an SMAppService login item; System Events lists it under the
  # app's name). Homebrew skips the login_item step on upgrades, so the
  # setting survives `brew upgrade`.
  uninstall quit:       "com.nosleep.app",
            login_item: "NoSleep"

  # Application Support holds the single-instance lock; the LaunchAgent is the
  # Start at Login mechanism of NoSleep <= 1.1.0, migrated away on first launch.
  zap trash: [
    "~/Library/Application Support/NoSleep",
    "~/Library/LaunchAgents/com.nosleep.app.plist",
    "~/Library/Preferences/com.nosleep.app.plist",
  ]

  caveats do
    <<~EOS
      NoSleep releases are ad-hoc signed and not notarized, so Gatekeeper blocks
      the first launch. Allow it once in System Settings -> Privacy & Security ->
      "Open Anyway", then launch again; or clear the quarantine flag:

        xattr -dr com.apple.quarantine /Applications/NoSleep.app

      Homebrew carries that approval forward on later upgrades.

      NoSleep asks for notification permission on first launch (the session-ended
      alert with its "Extend 1 hour" button). Ad-hoc signed releases get a new
      code identity every build, so macOS may ask again after an update.
    EOS
  end
end
