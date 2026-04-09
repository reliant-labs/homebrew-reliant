cask "reliant" do
  arch arm: "arm64", intel: "cb4b9de7b42ab2e4e0ef6f23af4b09d288ad131a20535f55f88a8a8ed9df1d06"

  version "1.4.0"
  sha256 arm:   "26203d9d85cad1ee253c6e450300565bb47ab0c5929884ba633c56d3263aedae",
         intel: "cb4b9de7b42ab2e4e0ef6f23af4b09d288ad131a20535f55f88a8a8ed9df1d06"

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
