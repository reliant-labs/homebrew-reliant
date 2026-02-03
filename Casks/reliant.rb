cask "reliant" do
  arch arm: "arm64", intel: "f1fcdec8bb43547d46d736df80732888becb1ce841860b068e83421cd59bdee3"

  version "1.0.0"
  sha256 arm:   "3591cb3868d4071ddd37e627d9bcbaf8e091b5df4f6f2cdd097dc03427e7bb63",
         intel: "f1fcdec8bb43547d46d736df80732888becb1ce841860b068e83421cd59bdee3"

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
