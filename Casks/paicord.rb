# This cask is auto-updated by the update-cask workflow.
# Do not edit the version or sha256 lines manually.
cask "paicord" do
  version "2026-07-12-f7dfbc1"
  sha256 "5f32897c0a220eb42206176145176f4c60e0fa6b77e70aee10f57a878a9bc56d"

  url "https://github.com/engels74/homebrew-paicord/releases/download/latest/Paicord.dmg"
  name "Paicord"
  desc "Native Discord client, written in Swift"
  homepage "https://github.com/llsc12/Paicord"

  depends_on macos: :sonoma

  app "Paicord.app"

  postflight do
    app_path = File.join(appdir, "Paicord.app")

    ohai "Removing quarantine attribute from #{app_path}"
    system_command "/usr/bin/xattr",
                   args:         ["-r", "-d", "com.apple.quarantine", app_path],
                   sudo:         false,
                   must_succeed: false
  end

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
