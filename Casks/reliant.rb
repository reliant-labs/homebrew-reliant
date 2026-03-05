cask "reliant" do
  arch arm: "arm64", intel: "bfdf0fa2bfaa022e8886f94baf3092ba7db838dd214ea745725ff8bca4df0175"

  version "1.0.3"
  sha256 arm:   "7e81e63c87885fc044e818deb12c1c195744943f9cee5dbafb7e908d547ad100",
         intel: "bfdf0fa2bfaa022e8886f94baf3092ba7db838dd214ea745725ff8bca4df0175"

  url "https://downloads.reliantlabs.io/Reliant-#{version}-mac-#{arch}.dmg"
  name "Reliant"
  desc "AI-powered coding assistant with intelligent agents"
  homepage "https://reliantlabs.io/"

  livecheck do
    url "https://downloads.reliantlabs.io/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Reliant.app"

  uninstall quit: "com.reliantlabs.reliant"

  zap trash: [
    "~/.reliant",
    "~/Library/Application Support/Reliant",
    "~/Library/Caches/com.reliantlabs.reliant",
    "~/Library/Caches/com.reliantlabs.reliant.ShipIt",
    "~/Library/HTTPStorages/com.reliantlabs.reliant",
    "~/Library/Logs/Reliant",
    "~/Library/Preferences/com.reliantlabs.reliant.plist",
    "~/Library/Saved Application State/com.reliantlabs.reliant.savedState",
  ]
end
