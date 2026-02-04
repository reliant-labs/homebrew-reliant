cask "reliant" do
  arch arm: "arm64", intel: "a684d24ad336442b63c15b3c9031ae91d02be3e84b55b26867d7d47dabc4155c"

  version "1.0.1"
  sha256 arm:   "f63308b2560f77d9cc832fa7e007eb9c4a570dc1ed66af2c6541b5f20b62cb51",
         intel: "a684d24ad336442b63c15b3c9031ae91d02be3e84b55b26867d7d47dabc4155c"

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
