# device_nothing_asteroids-recovery

Recovery tree for the Nothing Phone (3a), codenamed `asteroids`, currently heavy WIP.

## Checklist

### Basic functionality

- [ ] Installing and flashing images (unknown status)
    - [ ] .zip files
    - [ ] .img files
- [ ] Backup and restore
    - [ ] To external/removable devices (e.g. OTG device)
- [ ] Built-in features work normally
    - [x] ADB
        - [x] Sideload
    - [ ] FastbootD
    - [x] Screen and brightnesss
    - [x] Touchscreen
    - [ ] MTP
    - [ ] Filesystem/Mounts
    - [ ] Slot switch
    - [ ] Haptics
- [ ] Settings persistence
- [ ] Data decryption
    - [ ] Without a password
    - [ ] With a password

### Advanced functionality

- [ ] Recovery password protection
- [x] Flashlight
- [ ] Changing themes and splash after reboot

> [!NOTE]
> This functionality list was adapted from the [Maintainership requirements](https://wiki.orangefox.tech/en/dev/maintainerships#test-suite) of OrangeFox in the Test Suite section, and [chickendrop89](https://github.com/chickendrop89)'s [device tree](https://github.com/chickendrop89/device_xiaomi_amethyst-recovery) README.md file

## Credits

- The countless device trees I took inspiration from.
- [chickendrop89](https://github.com/chickendrop89)'s [device tree](https://github.com/chickendrop89/device_xiaomi_amethyst-recovery) for the Xiaomi Redmi Note _14 Pro+_ 5G, which has the same board and processor as the Nothing Phone (3a)
- [MrYacha](https://gitlab.com/MrYacha)'s original tree which I forked to continue his work.
- The [OrangeFox discord server](https://discord.gg/GpYTArw22N) which helped me through some of the hard work and gave tips.


