## Auto-Update Discord Script for Ubuntu

This Bash script automates the process of downloading and installing the latest version of Discord on Ubuntu systems.
Discord, for some weird reason. doesn't auto update on linux (ion my case, ubuntu) automatically, so I have to  manually download the deb file each time to be able to update discord which took approximately 15-20 minutes on a daily basis. 
So I started working on this script to rid me of that burden.

**Features:**

* Checks for internet connectivity before attempting updates (because it kept crashing when I set it to run on startup)
* Includes version checks to avoid unnecessary re-installations (why download the whole deb file over and over again)

**Requirements:**

* Ubuntu system
* Most other commands are usually preinstalled

**Installation:**

1. Clone this repository:

```bash
git clone https://github.com/i-am-zaidali/auto-update-discord/
```

2. Make the script executable:

```bash
cd auto-update-discord
chmod +x update-discord.sh
```

**Usage:**

1. Run the script manually:

```bash
./update-discord.sh
```

2. (Optional) Set up a cron job for automatic updates (refer to cron documentation for scheduling details) or set it to run on startup with `startup applications` on ubuntu.

**Explanation:**

* The script retrieves the latest Discord download URL using `curl`.
* It checks for internet connectivity before proceeding.
* The script downloads the package using `wget`.
* It utilizes `dpkg` to install the downloaded package.

**Disclaimer:**

This script is provided for educational purposes only. Use it at your own risk. The author is not responsible for any damages caused by its use.

**Contributions:**

Feel free to contribute to this project by submitting pull requests for improvements or bug fixes.
