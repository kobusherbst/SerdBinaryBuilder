using BinaryBuilder, BinaryBuilderBase, Pkg

name = "Serd"
version = v"0.32.4"

sources = [
    ArchiveSource(
        "https://download.drobilla.net/serd-0.32.4.tar.xz",
        "cbefb569e8db686be8c69cb3866a9538c7cb055e8f24217dd6a4471effa7d349"
    )
]
# Build script
script = raw"""
meson_path=$(dirname $(which meson))
ninja_path=$(dirname $(which ninja))
export PATH="$meson_path:$ninja_path:$PATH"

mkdir build && cd build

meson setup --prefix=${prefix} --buildtype=release --default-library=both --cross-file=${MESON_TARGET_TOOLCHAIN} ${WORKSPACE}/srcdir/serd-0.32.4

ninja -j${nproc}
ninja install

install -D -m644 ${WORKSPACE}/srcdir/serd-0.32.4/COPYING ${prefix}/share/licenses/Serd/COPYING
"""

# Platforms to build for
platforms = [
    Platform("x86_64", "windows"; libc = "mingw"),
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("x86_64", "macos"),
    Platform("aarch64", "macos"),
]

# Products that will be produced
products = [
    LibraryProduct(["libserd-0", "serd-0"], :libserd),
]

dependencies = []   # <- empty!

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies, julia_compat="1.7")
