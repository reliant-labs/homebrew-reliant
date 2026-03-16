cask "reliant" do
  arch arm: "arm64", intel: "ed327f57797bdbbced2ffef9cd7b56c72eb892839b08986d636fb7cae04398d6"

  version "1.2.0"
  sha256 arm:   "f0a2ec56f3c723b7263e3db9e3bc3b00d1206af9cb5cd35a15e81582380d75d4",
         intel: "ed327f57797bdbbced2ffef9cd7b56c72eb892839b08986d636fb7cae04398d6"

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
