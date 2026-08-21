cask "reliant" do
  arch arm: "arm64", intel: "298ee745537661b2b1601aa65bfb0f4ac88d28f8f053098d9e20cf7de0c7eb79"

  version "1.7.5"
  sha256 arm:   "b08ed98e9de549d2f11def8e3d8b14576654e399153df7a69e9ee46bd91c7b18",
         intel: "298ee745537661b2b1601aa65bfb0f4ac88d28f8f053098d9e20cf7de0c7eb79"

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
