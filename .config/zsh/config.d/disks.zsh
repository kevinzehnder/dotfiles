function show_disks() {
	echo "💾 Block devices:"
	lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID,FSTYPE,LABEL,MODEL

	echo -e "\n🧠 Memory info:"
	free -h

	echo -e "\n💽 Mounted filesystems:"
	df -Th | grep -v "tmpfs\|devtmpfs"
}

function mount_disk() {
	# Need sudo for this shit
	check_sudo_nopass || sudo -v

	# Get all block devices that aren't already mounted
	local devices=$(lsblk -lnpo NAME,TYPE,SIZE,FSTYPE,MOUNTPOINT,LABEL | grep -v "disk\\|loop\\| rom" | grep -v "[[:space:]]/$\\|[[:space:]]/boot" | awk '$5 == ""')

	if [[ -z "$devices" ]]; then
		echo "❌ No unmounted partitions found. Everything's already mounted."
		return 0
	fi

	# Use FZF to select a device
	local selected=$(echo "$devices" | fzf --height 40% --reverse --header="Select partition to mount:")

	if [[ -z "$selected" ]]; then
		echo "❌ No device selected. Pussy."
		return 1
	fi

	# Parse the device information
	local device=$(echo "$selected" | awk '{print $1}')
	local fstype=$(echo "$selected" | awk '{print $4}')

	# Detect filesystem if needed
	if [[ -z "$fstype" || "$fstype" == "crypto_LUKS" ]]; then
		echo "🔍 Detecting filesystem type..."
		fstype=$(blkid -o value -s TYPE "$device")
	fi

	# For LUKS, handle decryption
	if [[ "$fstype" == "crypto_LUKS" ]]; then
		echo "🔒 LUKS encrypted volume detected"
		local name=$(basename "$device")
		cryptsetup open "$device" "luks-$name"
		device="/dev/mapper/luks-$name"
		fstype=$(blkid -o value -s TYPE "$device")
	fi

	# Select mount point using FZF or create new
	echo "📂 Select mount point:"
	local mount_options=(
		"/mnt/usb"
		"/mnt/backup"
		"/mnt/data"
		"/media/external"
		"CREATE NEW"
	)

	local mount_point=$(printf "%s\n" "${mount_options[@]}" | fzf --height 40% --reverse)

	if [[ "$mount_point" == "CREATE NEW" ]]; then
		echo -n "🆕 Enter new mount point: /mnt/"
		read -r dir_name
		mount_point="/mnt/$dir_name"
	fi

	# Create mount point if it doesn't exist
	if [[ ! -d "$mount_point" ]]; then
		mkdir -p "$mount_point"
	fi

	# Mount that shit with appropriate options
	local mount_opts="defaults"

	case "$fstype" in
		ext4)
			mount_opts="defaults,noatime"
			;;
		ntfs | ntfs-3g)
			mount_opts="defaults,windows_names,uid=$(id -u),gid=$(id -g),umask=0022"
			fstype="ntfs-3g"
			;;
		vfat | fat | msdos)
			mount_opts="defaults,uid=$(id -u),gid=$(id -g),umask=0022"
			;;
		btrfs)
			mount_opts="defaults,noatime,compress=zstd"
			;;
		xfs)
			mount_opts="defaults,noatime"
			;;
	esac

	# Actually mount the damn thing
	if sudo mount -t "$fstype" -o "$mount_opts" "$device" "$mount_point"; then
		echo "✅ Mounted $device on $mount_point with options: $mount_opts"
		echo "UUID=$(blkid -o value -s UUID "$device") $mount_point $fstype $mount_opts 0 2"
		echo "👆 Add this to /etc/fstab if you want to make it permanent"
	else
		echo "❌ Mount failed. System said:"
		sudo mount -t "$fstype" -o "$mount_opts" "$device" "$mount_point" 2>&1
	fi
}

function add_to_fstab() {
	# Need sudo for this shit
	if [[ $EUID -ne 0 ]]; then
		echo "❌ Run with sudo, dickhead"
		return 1
	fi

	# Get current mounts excluding system mounts
	local mounts=$(mount | grep -v "tmpfs\|devtmpfs\|sysfs\|proc\| /dev\| /sys\| /run\| /boot\| /$" | sort)

	# Use FZF to select a mount to add
	local selected=$(echo "$mounts" | fzf --height 40% --reverse --header="Select mount to add to fstab:")

	if [[ -z "$selected" ]]; then
		echo "❌ No mount selected. Bye."
		return 1
	fi

	# Parse the mount information
	local device=$(echo "$selected" | awk '{print $1}')
	local mountpoint=$(echo "$selected" | awk '{print $3}')
	local fstype=$(grep -w "$mountpoint" /proc/mounts | awk '{print $3}')
	local options=$(grep -w "$mountpoint" /proc/mounts | awk '{print $4}')

	# Get the UUID
	local uuid=$(blkid -o value -s UUID "$device")

	if [[ -z "$uuid" ]]; then
		echo "❌ Couldn't get UUID for $device. Using device path instead."
		local fstab_entry="$device $mountpoint $fstype $options 0 2"
	else
		local fstab_entry="UUID=$uuid $mountpoint $fstype $options 0 2"
	fi

	echo "📝 About to add this to /etc/fstab:"
	echo "$fstab_entry"

	echo -n "❓ Proceed? [y/N]: "
	read -r confirm

	if [[ "$confirm" =~ ^[Yy]$ ]]; then
		sudo cp /etc/fstab /etc/fstab.backup
		echo "$fstab_entry" | sudo tee -a /etc/fstab > /dev/null
		echo "✅ Added to fstab. Backup created at /etc/fstab.backup"
	else
		echo "❌ Cancelled. Nothing changed."
	fi
}
