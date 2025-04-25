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

# Correct cross file
cat > cross_file.txt <<EOF
[binaries]
c = '/opt/aarch64-apple-darwin20/bin/aarch64-apple-darwin20-clang'
cpp = '/opt/aarch64-apple-darwin20/bin/aarch64-apple-darwin20-clang++'
ar = '/opt/aarch64-apple-darwin20/bin/aarch64-apple-darwin20-ar'
strip = '/opt/aarch64-apple-darwin20/bin/aarch64-apple-darwin20-strip'
pkgconfig = 'pkg-config'

[host_machine]
system = 'darwin'
cpu_family = 'aarch64'
cpu = 'arm64'
endian = 'little'
EOF

# Now setup using correct cross file
meson setup --prefix=${prefix} --buildtype=release --default-library=both --cross-file=cross_file.txt ${WORKSPACE}/srcdir/serd-0.32.4

ninja -j${nproc}
ninja install

install -D -m644 ${WORKSPACE}/srcdir/serd-0.32.4/COPYING ${prefix}/share/licenses/Serd/COPYING
"""


# Platforms to build for
platforms = [
    Platform("x86_64", "windows"; libc = "mingw"),
    Platform("x86_64", "linux"; libc = "glibc"),
]

# Products that will be produced
products = [
    LibraryProduct(["libserd-0", "serd-0"], :libserd),
]

dependencies = []   # <- empty!

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies, julia_compat="1.7")
