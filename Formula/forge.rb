class Forge < Formula
  desc "Production-ready Go + Connect RPC + Postgres + Next.js project framework"
  homepage "https://github.com/reliant-labs/forge"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.15/forge_darwin_arm64.tar.gz"
      sha256 "fff0e15eeb7a9b5b182cf13fcab2b0367b41f23aa338802d7c2145145c2fe221"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.15/forge_darwin_amd64.tar.gz"
      sha256 "cc35dfc3d5ae537f09091959524a9b9db23005dab760cecdc018ad7be678373f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.15/forge_linux_arm64.tar.gz"
      sha256 "f6795b207c3588734cdc2624b343abf7b3c234143446c68c57fff1380ad7488a"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.15/forge_linux_amd64.tar.gz"
      sha256 "cebfae4b0584d69149dc3672732975cfc9a8670c1473c12c82245a25ff579a03"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
