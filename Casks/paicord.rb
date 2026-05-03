# This cask is auto-updated by the update-cask workflow.
# Do not edit the version or sha256 lines manually.
cask "paicord" do
  version "2026-05-03-25cc456"
  sha256 "6c004daf9fb085568ccf35b9393c1e18fecce510432c18909502e72f2246ede6"

  url "https://github.com/engels74/homebrew-paicord/releases/download/latest/Paicord.dmg"
  name "Paicord"
  desc "Native Discord client for macOS, written in Swift"
  homepage "https://github.com/llsc12/Paicord"

  depends_on macos: ">= :sonoma"

  app "Paicord.app"

  zap trash: [
    "~/Library/Application Support/com.llsc12.Paicord",
    "~/Library/Caches/com.llsc12.Paicord",
    "~/Library/HTTPStorages/com.llsc12.Paicord",
    "~/Library/Preferences/com.llsc12.Paicord.plist",
    "~/Library/Saved Application State/com.llsc12.Paicord.savedState",
    "~/Library/WebKit/com.llsc12.Paicord",
  ]

  caveats <<~EOS
    Paicord is an unofficial, third-party Discord client.
    Using it is a violation of Discord's Terms of Service.
    Your account may be suspended or banned. Use at your own risk.
  EOS
end
