using BinaryBuilder, BinaryBuilderBase

name = "Serd"
version = v"0.32.4"

sources = [
    ArchiveSource("https://download.drobilla.net/serd-0.32.4.tar.xz",
                  "cbefb569e8db686be8c69cb3866a9538c7cb055e8f24217dd6a4471effa7d349"),
]

# The actual build script
script = raw"""
meson_path=$(dirname $(which meson))
ninja_path=$(dirname $(which ninja))
export PATH="$meson_path:$ninja_path:$PATH"

mkdir build && cd build

if [[ "${target}" == *w64-mingw32* ]]; then
    echo "Detected Windows target, generating custom cross file..."

    cat > cross_file_windows.txt <<EOF
[binaries]
c = '/opt/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-gcc'
cpp = '/opt/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-g++'
ar = '/opt/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-ar'
strip = '/opt/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-strip'
pkgconfig = 'pkg-config'

[host_machine]
system = 'windows'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
EOF

    meson setup --prefix=${prefix} --libdir=lib --buildtype=release --default-library=shared --cross-file=cross_file_windows.txt ${WORKSPACE}/srcdir/serd-0.32.4
else
    echo "Non-Windows target detected, using default MESON_TARGET_TOOLCHAIN..."

    meson setup --prefix=${prefix} --libdir=lib --buildtype=release --default-library=both --cross-file=${MESON_TARGET_TOOLCHAIN} ${WORKSPACE}/srcdir/serd-0.32.4
fi

ninja -j${nproc}
ninja install

install -D -m644 ${WORKSPACE}/srcdir/serd-0.32.4/COPYING ${prefix}/share/licenses/Serd/COPYING

echo "=== Installed files ==="
find ${prefix}
"""

# Products
products = [
    LibraryProduct(["libserd-0"], :libserd; dont_dlopen=true),
    LibraryProduct(["libserd-0"], :libserd; dont_dlopen=true),
]

# Supported platforms
platforms = [
    Platform("x86_64", "linux"; libc="glibc"),
    Platform("x86_64", "windows"; libc="mingw"),
]

# No dependencies
dependencies = []

# Actually build
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies;
    julia_compat = "1.6",
    skip_audit = true,
)
