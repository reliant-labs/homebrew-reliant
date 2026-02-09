cask "reliant" do
  arch arm: "arm64", intel: "8434ba0fdfa32ed917942afb3743c4f444c6f9dfabdf37cc5e07098e0a8b63e3"

  version "1.0.2"
  sha256 arm:   "2984d340267b9ce45cd05bb00c0480b2bbb1dd2fffbdbecba0a71f561acdf6a2",
         intel: "8434ba0fdfa32ed917942afb3743c4f444c6f9dfabdf37cc5e07098e0a8b63e3"

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
