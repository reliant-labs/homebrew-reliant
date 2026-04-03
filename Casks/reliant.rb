cask "reliant" do
  arch arm: "arm64", intel: "8e27e9a3fdc3a98094c1026c7646c9805d86bbfdba8b03b1adc5846d81613b94"

  version "1.3.0"
  sha256 arm:   "acb3b4e35dbf52574cedc0932a381726edf58f0fabdf11e9d5be391dc8a86235",
         intel: "8e27e9a3fdc3a98094c1026c7646c9805d86bbfdba8b03b1adc5846d81613b94"

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
