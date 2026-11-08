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
      url "https://github.com/reliant-labs/forge/releases/download/v1.2.0/forge_darwin_arm64.tar.gz"
      sha256 "7e3dbab0d518f8e3c5d2c54148524fb48ac3c64889ec4276ac6c5ba73c0d8105"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.2.0/forge_darwin_amd64.tar.gz"
      sha256 "5512375f1dbe29d819f90182609ac31e17ac2eef15359622e1d3ddfb72e208d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.2.0/forge_linux_arm64.tar.gz"
      sha256 "10d4f6c67df1c60b1a930568bb93bc2ae1aeec7002fd92d0c3d3b1de5377e774"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.2.0/forge_linux_amd64.tar.gz"
      sha256 "29abda0959c7793ad484bc806f7caeecd6d2cdcb5df7de030a18a3f53da32724"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
