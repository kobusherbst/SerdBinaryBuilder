using BinaryBuilder, BinaryBuilderBase, Pkg

name = "Serd"
version = v"0.32.4"

sources = [
    ArchiveSource(
        "https://download.drobilla.net/serd-0.32.4.tar.xz",
        "553a9b50caa23a7c57732f83e6f80658"
    ),
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

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
