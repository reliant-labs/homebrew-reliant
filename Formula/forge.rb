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
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.14/forge_darwin_arm64.tar.gz"
      sha256 "4f20233dad2ef6767cf6c3df1bc02fdba375ff08024741581eec608bc809f36b"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.14/forge_darwin_amd64.tar.gz"
      sha256 "be6185c544e9a8c12b9b02860aaddff3f57b161b2fad0e6b964b347b746cfcf5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.14/forge_linux_arm64.tar.gz"
      sha256 "379402e1274dfd58f5b0654fa9c99a5105860ef29dfe37f98bdb671a5a13358d"
    end
    on_intel do
      url "https://github.com/reliant-labs/forge/releases/download/v1.0.14/forge_linux_amd64.tar.gz"
      sha256 "e85b9a6c5bec2532e5bbc32245606739baa30dcf016501d524e37465bc5f52e8"
    end
  end

  def install
    bin.install "forge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")
  end
end
