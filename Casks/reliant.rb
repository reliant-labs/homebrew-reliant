cask "reliant" do
  arch arm: "arm64", intel: "x64"

  version "1.28.1"
  sha256 arm:   "755c367b09cc4f3673415b37059dd6e40df721390c8dcc8d807a387d728adef5",
         intel: "2a72a0a98bc25979bdad8445f6944c45b4c3f975fb578cf8106308f50a0499db"

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
