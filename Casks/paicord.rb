# This cask is auto-updated by the update-cask workflow.
# Do not edit the version or sha256 lines manually.
cask "paicord" do
  version "0000-00-00-0000000"
  sha256 "2c5e92b1ea619fce6ecdc22ddb1a65fdb3aa589703b29794afd3646ae43c52a5"

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
