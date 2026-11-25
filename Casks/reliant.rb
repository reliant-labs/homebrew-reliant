cask "reliant" do
  arch arm: "arm64", intel: "x64"

  version "1.31.0"
  sha256 arm:   "10291b808153f61fd3cc2670c85e9e84a397e8f6476c8124adf744ffb7b39f42",
         intel: "fa72fbbdf1c61e45b1e089e37cfc39d5ccddd86cec1dc38b50030fe057449398"

  url "https://downloads.reliantlabs.io/Reliant-#{version}-mac-#{arch}.dmg"
  name "Reliant"
  desc "AI-powered coding assistant with intelligent agents"
  homepage "https://reliantlabs.io/"

  livecheck do
    url "https://downloads.reliantlabs.io/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: :monterey

  app "Reliant.app"

  binary "Reliant.app/Contents/Resources/server/mac-#{arch}/reliant-backend", target: "reliant"

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
