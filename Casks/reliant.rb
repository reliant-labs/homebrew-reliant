cask "reliant" do
  arch arm: "arm64", intel: "4ec7c8ee4a366a44328397996a698b10320c5b2cda1551dc67484b72c2e622d3"

  version "1.0.4"
  sha256 arm:   "10839290b08322b32fa04974444a47e364aa4c51235b1d58fd49489bee9ea78a",
         intel: "4ec7c8ee4a366a44328397996a698b10320c5b2cda1551dc67484b72c2e622d3"

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
