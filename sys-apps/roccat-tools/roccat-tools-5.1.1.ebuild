# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit readme.gentoo cmake-utils gnome2-utils udev user

DESCRIPTION="Utility for advanced configuration of Roccat devices"

HOMEPAGE="http://roccat.sourceforge.net/"
SRC_URI="mirror://sourceforge/roccat/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_INPUT_DEVICES="
	input_devices_roccat_arvo
	input_devices_roccat_isku
	input_devices_roccat_iskufx
	input_devices_roccat_kiro
	input_devices_roccat_kone
	input_devices_roccat_koneplus
	input_devices_roccat_konepure
	input_devices_roccat_konepuremilitary
	input_devices_roccat_konepureoptical
	input_devices_roccat_konextd
	input_devices_roccat_konextdoptical
	input_devices_roccat_kovaplus
	input_devices_roccat_kova2016
	input_devices_roccat_lua
	input_devices_roccat_nyth
	input_devices_roccat_pyra
	input_devices_roccat_ryosmk
	input_devices_roccat_ryostkl
	input_devices_roccat_savu
	input_devices_roccat_tyon
"
IUSE="${IUSE_INPUT_DEVICES}"

RDEPEND="
	=dev-libs/libgaminggear-0.13*
	x11-libs/gtk+:2
	x11-libs/libnotify
	media-libs/libcanberra
	virtual/libusb:1
	dev-libs/dbus-glib
	virtual/libgudev:=
	|| ( dev-lang/lua:5.1 dev-lang/lua:0 )
"

DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup roccat
}

src_configure() {
	local UDEVDIR="$(get_udevdir)"/rules.d
	local MODELS=${INPUT_DEVICES//roccat_/}
	mycmakeargs=(
		-DDEVICES=${MODELS// /;} \
		-DUDEVDIR="${UDEVDIR/"//"//}"
		-DWITH_LUA=5.1
	)
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	local stat_dir=/var/lib/roccat
	keepdir $stat_dir
	fowners root:roccat $stat_dir
	fperms 2770 $stat_dir
	readme.gentoo_src_install
}
pkg_preinst() {
	gnome2_icon_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_print_elog
	ewarn
	ewarn "This version breaks stored data for some devices. Before reporting bugs please delete"
	ewarn "affected folder(s) in /var/lib/roccat"
	ewarn
}

pkg_postrm() {
	gnome2_icon_cache_update
}
