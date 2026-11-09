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
      url "https://github.com/reliant-labs/forge/releases/download/v1.3.0/forge_darwin_arm64.tar.gz"
      sha256 "a981deebeb5e5c8a476a3e0a056be0a8ba6e91faf71a1d483a8989d1e5540f1d"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.3.0/forge_darwin_amd64.tar.gz"
      sha256 "36373c1f58aa8db8fc7b10a03a6e771c173162a7d1bbb1e49be3d2a02942d4e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.3.0/forge_linux_arm64.tar.gz"
      sha256 "aa6d982decefc6728d3e2725b531af14ecd68e099b04b0ca2d901a1eaa9d7aaf"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.3.0/forge_linux_amd64.tar.gz"
      sha256 "06796179e57a17b6efea73ab135c5dcaa173456924a8e8211d6d243fb831ad9c"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
