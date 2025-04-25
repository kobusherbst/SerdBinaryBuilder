using BinaryBuilder, BinaryBuilderBase, Pkg

name = "Serd"
version = v"0.32.4"

sources = [
    ArchiveSource(
        "https://download.drobilla.net/serd-0.32.4.tar.xz",
        "e4b1ce4d63b1e5b0e6c0a3a5abf994d4ab0e2f2f41e59e36c0aaf66ed21a1c74"
    )
]
script = raw"""
pip3 install meson ninja

mkdir build && cd build

meson setup --prefix=${prefix} --buildtype=release --default-library=both --cross-file=${MESON_TARGET_TOOLCHAIN} ..
ninja -j${nproc}
ninja install

install -D -m644 ../COPYING ${prefix}/share/licenses/Serd/COPYING
"""

platforms = [
    Platform("x86_64", "windows"; libc = "mingw"),
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("x86_64", "macos"),
    Platform("aarch64", "macos")
]

products = [
    LibraryProduct(["libserd-0", "serd-0"], :libserd),
]

dependencies = []

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies, julia_compat="1.7")
