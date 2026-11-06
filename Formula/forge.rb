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
      url "https://github.com/reliant-labs/forge/releases/download/v1.1.0/forge_darwin_arm64.tar.gz"
      sha256 "d51b43e87d3f88be87e0322bd385bc109a24992f59700b5530d2a225d9c1fbc6"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.1.0/forge_darwin_amd64.tar.gz"
      sha256 "1eef647f177a95ec4431aaafcef0460e00578ed2215e16fa6f0846f3da317fde"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.1.0/forge_linux_arm64.tar.gz"
      sha256 "cd8381e3368890fc25f2ac41d7cbe5b5cc31d4f0bd57eba96bc60289d4135fb4"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.1.0/forge_linux_amd64.tar.gz"
      sha256 "8cb85764fb4b36cd9309df8ab2215b2048ebc236798f4ea6de554f4e97b11dc0"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
