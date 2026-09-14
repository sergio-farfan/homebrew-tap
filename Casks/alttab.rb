cask "alttab" do
  version "1.3.2"
  sha256 "cf4d9f4eb1804ed7153ae55d2b16ba248cf2efee44675a81e7c8aee0fa7feec9"

  url "https://github.com/sergio-farfan/alttab-macos/releases/download/v#{version}/AltTab-#{version}.dmg"
  name "AltTab"
  desc "Windows-style window switcher"
  homepage "https://github.com/sergio-farfan/alttab-macos"

  livecheck do
    url :url
    strategy :github_latest
  end

  # lwouis/alt-tab-macos (homebrew/cask token "alt-tab") also installs /Applications/AltTab.app.
  conflicts_with cask: "alt-tab"
  depends_on macos: :ventura

  app "AltTab.app"

  uninstall quit: "com.alttab.app"

  zap trash: "~/Library/Preferences/com.alttab.app.plist"

  caveats do
    unsigned_accessibility
    <<~EOS
      AltTab releases are ad-hoc signed and not notarized, so Gatekeeper blocks
      the first launch. Allow it once in System Settings -> Privacy & Security ->
      "Open Anyway", then launch again.

      If Option-Tab stops working after an update while the Accessibility toggle
      is still on:

        tccutil reset Accessibility com.alttab.app
    EOS
  end
end
