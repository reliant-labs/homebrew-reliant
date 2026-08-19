cask "reliant" do
  arch arm: "arm64", intel: "76083faa2f34d561f0b3fd5c9d0fca0f96016e2c8d1abe80110baf70b1b3b1e5"

  version "1.7.0"
  sha256 arm:   "52df38469506ec694f302fc10a91fd332d08cbb9f45b874b1fa10d3f3b971321",
         intel: "76083faa2f34d561f0b3fd5c9d0fca0f96016e2c8d1abe80110baf70b1b3b1e5"

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
