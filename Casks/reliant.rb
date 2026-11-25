cask "reliant" do
  arch arm: "arm64", intel: "x64"

  version "1.30.0"
  sha256 arm:   "0858ac6ee70667806c43222d75160ccea16193286bc8e127bcf484718c5e0437",
         intel: "dcf973af11f9e0be1c9337239358588d77668bc39cbaf6dbe34772c5c8e660d5"

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
