#!/bin/bash -euo

# Add workaround for SSH-based Git connections from Rust/cargo.  See https://github.com/rust-lang/cargo/issues/2078 for details.
# We set CARGO_HOME because we don't pass on HOME to conda-build, thus rendering the default "${HOME}/.cargo" defunct.
export CARGO_NET_GIT_FETCH_WITH_CLI=true CARGO_HOME="$(pwd)/.cargo"
# Make sure bindgen passes on our compiler flags.
export BINDGEN_EXTRA_CLANG_ARGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
if [[ -n "$OSX_ARCH" ]]; then
    # Set this so that it doesn't fail with open ssl errors
    export RUSTFLAGS="-C link-arg=-undefined -C link-arg=dynamic_lookup"
fi

RUST_BACKTRACE=1 cargo install --verbose --path . --root $PREFIX