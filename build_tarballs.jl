using BinaryBuilder
using BinaryBuilderBase

name = "Serd"
version = v"0.32.4"

sources = [
    ArchiveSource(
        "https://download.drobilla.net/serd-0.32.4.tar.xz",
        "cbefb569e8db686be8c69cb3866a9538c7cb055e8f24217dd6a4471effa7d349"
    )
]

script = raw"""
meson_path=$(dirname $(which meson))
ninja_path=$(dirname $(which ninja))
export PATH="$meson_path:$ninja_path:$PATH"

mkdir build && cd build

meson setup --prefix=${prefix} --buildtype=release --default-library=shared ${WORKSPACE}/srcdir/serd-0.32.4

ninja -j${nproc}
ninja install

# Install license
install -D -m644 ${WORKSPACE}/srcdir/serd-0.32.4/COPYING ${prefix}/share/licenses/Serd/COPYING

# Manually create missing symlinks
cd ${prefix}/lib
if [[ -f "libserd-0.so.0.32.4" ]]; then
    ln -sf libserd-0.so.0.32.4 libserd-0.so.0
    ln -sf libserd-0.so.0 libserd-0.so
fi

"""

platforms = [
    Platform("x86_64", "linux"; libc="glibc"),
    Platform("x86_64", "windows"; libc="mingw")
]

dependencies = []

products = [
    LibraryProduct(["libserd-0.so.0.32.4"], :serd)
]

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies;
    julia_compat = "1.6",
    skip_audit = true
)