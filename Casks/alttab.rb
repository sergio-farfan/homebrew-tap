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

  depends_on macos: ">= :ventura"

  app "AltTab.app"

  uninstall quit: "com.alttab.app"

  zap trash: [
    "~/Library/Preferences/com.alttab.app.plist",
  ]

  caveats do
    <<~EOS
      AltTab releases are not yet notarized. If macOS blocks the first launch,
      either right-click AltTab.app -> Open, or install without quarantine:

        brew install --cask --no-quarantine sergio-farfan/tap/alttab

      AltTab needs the Accessibility permission (System Settings -> Privacy &
      Security -> Accessibility). Because releases are ad-hoc signed, macOS
      re-prompts for that permission once after every update; if the toggle
      looks stuck ON but Option-Tab is dead:

        tccutil reset Accessibility com.alttab.app
    EOS
  end
end
