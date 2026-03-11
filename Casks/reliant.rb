cask "reliant" do
  arch arm: "arm64", intel: "15786d6e80854413562e9481c4c75aad6744fd8a81ec9f220cb6eec2fa13ab2a"

  version "1.1.0"
  sha256 arm:   "9370e5986bfc6ae21f70b090d57888413fae8ce3c742bd6a090c6c7f3afb02d8",
         intel: "15786d6e80854413562e9481c4c75aad6744fd8a81ec9f220cb6eec2fa13ab2a"

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
