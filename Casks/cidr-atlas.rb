cask "cidr-atlas" do
  version "0.4.1"
  sha256 "a3d76b75ec856ddbb5730ac19ea8a12a86ef0aa3ad34a8c1cbbe38d03af219cf"

  url "https://github.com/sergio-farfan/cidr-atlas/releases/download/v#{version}/CIDR-Atlas-#{version}.dmg"
  name "CIDR Atlas"
  desc "Local-first IP address inventory and CIDR allocation planner"
  homepage "https://github.com/sergio-farfan/cidr-atlas"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "CIDR Atlas.app"
  # The disk image carries one command-line executable per architecture: a Dart
  # AOT executable cannot be made universal.
  binary "cidrctl-#{on_arch_conditional arm: "arm64", intel: "x86_64"}", target: "cidrctl"

  uninstall quit: "dev.cidratlas.desktop"

  # The inventory in ~/Library/Application Support/cidr_atlas is shared with
  # cidrctl and deliberately left in place; deleting it is a separate step.
  zap trash: [
    "~/Library/Application Support/dev.cidratlas.desktop",
    "~/Library/Preferences/dev.cidratlas.desktop.plist",
  ]

  caveats do
    <<~EOS
      CIDR Atlas releases are ad-hoc signed and not notarized, so Gatekeeper blocks
      the first launch. Allow it once in System Settings -> Privacy & Security ->
      "Open Anyway", then launch again; or clear the quarantine flag:

        xattr -dr com.apple.quarantine "/Applications/CIDR Atlas.app"

      Expect that prompt again after every `brew upgrade`: ad-hoc builds get a
      new code identity each release, so the approval cannot carry over until
      releases are notarized.

      This cask also installs the `cidrctl` command. It carries the same
      download quarantine flag, so macOS may block its first run; allow it in
      System Settings -> Privacy & Security, or clear the flag:

        xattr -d com.apple.quarantine "$(readlink -f "$(brew --prefix)/bin/cidrctl")"

      On a managed Mac, endpoint security software may remove the unsigned
      executable on first run; ask your administrator to allow it, then run
      `brew reinstall --cask cidr-atlas`.

      Uninstalling, even with --zap, keeps your inventory; to delete it, export a
      backup first and remove ~/Library/Application Support/cidr_atlas yourself.
    EOS
  end
end
