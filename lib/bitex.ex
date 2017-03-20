defmodule Bitex do
  @moduledoc """
  Documentation for Bitex.

  MacOS installation
    Install OpenSSL:
      * brew install openssl
      * echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile
      * openssl version (must be "OpenSSL 1.0.2k  26 Jan 2017" or more)

    To compile deps:
      * export LDFLAGS=-L/usr/local/opt/openssl/lib
      * export CPPFLAGS=-I/usr/local/opt/openssl/include
      * export CFLAGS=-I/usr/local/opt/openssl/include
      * export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

      * mix do deps.get, deps.compile

  """

end
