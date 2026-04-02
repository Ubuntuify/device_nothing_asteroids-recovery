# device_nothing_asteroids-recovery

Recovery tree for the Nothing Phone (3a), codenamed `asteroids`.


## Information

Device                  | Nothing Phone (3a) / Pro
:-----------------------|:-------------------------------------------
SoC                     | Qualcomm Snapdragon® 7s Gen 3 (SM7635)
Board                   | `volcano`
CPU                     | Octa-core (1x2.5 GHz Cortex-A720 & 3x2.4 GHz Cortex-A720 & 4x1.8 GHz Cortex-A520)
GPU                     | Adreno 810
Memory                  | 8/12 GB RAM
Shipped Android version | Android 15 (Nothing OS 3.0)
Storage                 | 128/256 GB UFS 2.2
Micro SD                | None
Battery                 | Non-removable 5000 mAh
Dimensions              | 163.5 x 77.5 x 8.4 mm
Display                 | 6.77" AMOLED, 120hz

Recovery        | OrangeFox Recovery R11.3_1
:---------------|:---------------------------
Variant         | 6.1 (stock ROM only)
Manifest used   | `fox_14.1`

> [!NOTE]
> This branch only works on stock ROM right now since custom ROMs are running on a different kernel version.
> Please don't ask for support until I add it sometime later.

## Checklist

### Functionality

- [x] Installing and flashing images
    - [x] .zip files (experimental)
    - [x] .img files (working)
- [x] Backup and restore
    - [x] To external/removable devices (e.g. OTG device)
- [x] Built-in features work normally
    - [x] ADB
        - [x] Sideload
    - [x] FastbootD
    - [x] Screen and brightnesss
    - [x] Touchscreen
    - [x] MTP
    - [x] Filesystem/Mounts
    - [x] Slot switch
    - [ ] Haptics
- [x] Settings persistence
- [x] Data decryption
    - [x] Without a password
    - [x] With a password

### Advanced functionality

- [x] Recovery password protection
- [x] Flashlight
- [x] Changing themes and splash after reboot

> [!NOTE]
> This functionality list was adapted from the [Maintainership requirements](https://wiki.orangefox.tech/en/dev/maintainerships#test-suite) of OrangeFox in the Test Suite section, and [chickendrop89](https://github.com/chickendrop89)'s [device tree](https://github.com/chickendrop89/device_xiaomi_amethyst-recovery) README.md file

## Credits

- The countless device trees I took inspiration from.
- [chickendrop89](https://github.com/chickendrop89)'s [device tree](https://github.com/chickendrop89/device_xiaomi_amethyst-recovery) for the Xiaomi Redmi Note _14 Pro+_ 5G, which has the same board and processor as the Nothing Phone (3a)
- [ROM dumps](https://dumps.tadiphone.dev/dumps/nothing/asteroids/-/tree/qssi_64-user-16-BQ2A.250721.001-BP2A.250605.031.A3-2511181551-release-keys?ref_type=heads) from the Nothing Phone (3a), which I took some files from in order to make this device tree.
- [MrYacha](https://gitlab.com/MrYacha)'s original tree which I forked to continue his work.
- The [OrangeFox discord server](https://discord.gg/GpYTArw22N) which helped me through some of the hard work and gave tips.


