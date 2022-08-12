#ifndef _ATA_H_
#define _ATA_H_ 1

/**
 * https://ata.wiki.kernel.org/index.php/Developer_Resources
 * http://www.ata-atapi.com/index.html
 * https://www.computerhope.com/jargon/a/ata.htm
 * https://www.pjrc.com/mp3/gallery/cs580/ata_atapi.html
 * https://wiki.osdev.org/ATA/ATAPI_using_DMA
 **/

// Command Block Registers
#define ATA_REG_DATA            0x00
#define ATA_REG_ERROR           0x01    // Read
#define ATA_REG_FEATURES        0x01    // Write
#define ATA_REG_SECTOR_COUNT0   0x02
#define ATA_REG_LBA0            0x03
#define ATA_REG_LBA1            0x04
#define ATA_REG_LBA2            0x05
#define ATA_REG_DEVICE          0x06
#define ATA_REG_STATUS          0x07    // Read
#define ATA_REG_COMMAND         0x07    // Write
// For LBA48
#define ATA_REG_SECTOR_COUNT1   0x08
#define ATA_REG_LBA3            0x09
#define ATA_REG_LBA4            0x0A
#define ATA_REG_LBA5            0x0B
// Control Block Registers
#define ATA_REG_ALTSTATUS       0x0C    // Read
#define ATA_REG_CONTROL         0x0C    // Write
// #define ATA_REG_DEVADDR     0x01    // Read Only

/**
 * ERROR Register
 **/
// #define ATA_ERR_NTRACK0 0x02    // Track 0 not found
#define ATA_ERROR_NM    0x02    // No Media     ////Address mask not found
#define ATA_ERROR_ABRT  0x04    // Command aborted
#define ATA_ERROR_MCR   0x08    // Media change request
#define ATA_ERROR_IDNF  0x10    // ID mask not found
#define ATA_ERROR_MC    0x20    // Media changed
#define ATA_ERROR_WP    0x40    // Write Protect
#define ATA_ERROR_UNC   0x40    // Uncorrectable data
#define ATA_ERROR_ICRC  0x80    // Interface CRC error

/**
 * DEVICE Register
 * Low 4-bit is LBA (27:24) when using LBA28
 **/
#define ATA_DEVICE_DEV_SHIFT    4
#define ATA_DEVICE_DEV          (1 << ATA_DEVICE_DEV_SHIFT)    // Specify the selected device
#define ATA_DEVICE_LBA          0x40    // Specify the address is an LBA

/**
 * CONTROL Register
 * Low 4-bit is LBA (27:24) when using LBA28
 **/
#define ATA_CONTROL_NIEN_SHIFT  1
#define ATA_CONTROL_NIEN        (1 << ATA_CONTROL_NIEN_SHIFT)    // IRQ disable
#define ATA_CONTROL_SRST        0x04    // software reset bit
#define ATA_CONTROL_HOB         0x80    // high order byte - 48-bit address feature set

/**
 * STATUS Register
 **/ 
#define ATA_STATUS_BSY  0x80    // Busy
#define ATA_STATUS_DRDY 0x40    // Device ready
#define ATA_STATUS_DF   0x20    // Device fault
#define ATA_STATUS_DSC  0x10    // Device seek complete
#define ATA_STATUS_DRQ  0x08    // Data request
#define ATA_STATUS_CORRECT  0x04    // Corrected data - Obsolete in ATA/ATAPI 6
#define ATA_STATUS_IDX  0x02    // Index - Obsolete in ATA/ATAPI 6
#define ATA_STATUS_ERR  0x01    // Error

/**
 * ATA COMMAND SET
 * EXT: For 48-bit Address feature set
 **/
#define ATA_CMD_NOP                     0x00
#define ATA_CMD_DEVICE_RESET            0x08
#define ATA_CMD_READ_SECTORS            0x20
#define ATA_CMD_READ_SECTORS_EXT        0x24
#define ATA_CMD_READ_DMA_EXT            0x25
#define ATA_CMD_READ_DMA_QUEUED_EXT     0x26
#define ATA_CMD_READ_MAX_ADDRESS_EXT    0x27
#define ATA_CMD_READ_MULTIPLE_EXT       0x29
#define ATA_CMD_READ_LOG_EXT            0x2F
#define ATA_CMD_WRITE_SECTORS           0x30
#define ATA_CMD_WRITE_SECTORS_EXT       0x34
#define ATA_CMD_WRITE_DMA_EXT           0x35
#define ATA_CMD_WRITE_DMA_QUEUED_EXT    0x36
#define ATA_CMD_SET_MAX_ADDRESS_EXT     0x37
#define ATA_CMD_WRITE_MULTIPLE_EXT      0x39
#define ATA_CMD_WRITE_LOG_EXT           0x3F
#define ATA_CMD_READ_VERIFY_SECTORS     0x40
#define ATA_CMD_READ_VERIFY_SECTORS_EXT 0x42
#define ATA_CMD_SEEK                    0x70
#define ATA_CMD_DEVICE_DIAGNOSTIC       0x90
#define ATA_CMD_DOWNLOAD_MICROCODE      0x92
#define ATA_CMD_PACKET                  0xA0
#define ATA_CMD_IDENTIFY_PACKET         0xA1
#define ATA_CMD_SERVICE                 0xA2
/**
 *          SMART Feature register values
 * Features-register                Command
 *      0xD0                    SMART READ DATA
 *      0xD1                        Obsolete
 *      0xD2            SMART ENABLE/DISABLE ATTRIBUTE AUTOSAVE
 *      0xD3                        Obsolete
 *      0xD4               SMART EXECUTE OFF-LINE IMMEDIATE
 *      0xD5                    SMART READ LOG
 *      0xD6                    SMART WRITE LOG
 *      0xD7                        Obsolete
 *      0xD8                SMART ENABLE OPERATIONS
 *      0xD9                SMART DISABLE OPERATIONS
 *      0xDA                  SMART RETURN STATUS
 *      0xDB                        Obsolete
 **/
#define ATA_CMD_SMART                   0xB0
#define ATA_CMD_DEVICE_CONFIG_RESTORE   0xB1    // Features register - 0xC0
#define ATA_CMD_DEVICE_CONFIG_LOCK      0xB1    // Features register - 0xC1
#define ATA_CMD_DEVICE_CONFIG_IDENTIFY  0xB1    // Features register - 0xC2
#define ATA_CMD_DEVICE_CONFIG_SET       0xB1    // Features register - 0xC3
#define ATA_CMD_READ_MULTIPLE           0xC4
#define ATA_CMD_WRITE_MULTIPLE          0xC5
#define ATA_CMD_SET_MULTIPLE_MODE       0xC6
#define ATA_CMD_READ_DMA_QUEUED         0xC7
#define ATA_CMD_READ_DMA                0xC8
#define ATA_CMD_WRITE_DMA               0xCA
#define ATA_CMD_WRITE_DMA_QUEUED        0xCC
#define ATA_CMD_CHECK_MEDIA_CARD_TYPE   0xD1
#define ATA_CMD_GET_MEDIA_STATUS        0xDA
#define ATA_CMD_MEDIA_LOCK              0xDE
#define ATA_CMD_MEDIA_UNLOCK            0xDF
#define ATA_CMD_STANDBY_IMMEDIATE       0xE0
#define ATA_CMD_IDLE_IMMEDIATE          0xE1
#define ATA_CMD_STANDBY                 0xE2
#define ATA_CMD_IDLE                    0xE3
#define ATA_CMD_READ_BUFFER             0xE4
#define ATA_CMD_CHECK_POWER_MODE        0xE5
#define ATA_CMD_SLEEP                   0xE6
#define ATA_CMD_FLUSH_CACHE             0xE7
#define ATA_CMD_WRITE_BUFFER            0xE8
#define ATA_CMD_FLUSH_CACHE_EXT         0xEA
#define ATA_CMD_IDENTIFY                0xEC
#define ATA_CMD_MEDIA_EJECT             0xED
#define ATA_CMD_SET_FEATURES            0xEF
#define ATA_CMD_SET_PASSWORD            0xF1
#define ATA_CMD_FREEZE_UNLOCK           0xF2
#define ATA_CMD_ERASE_PREPARE           0xF3
#define ATA_CMD_ERASE_UINT              0xF4
#define ATA_CMD_FREEZE_LOCK             0xF5
#define ATA_CMD_DISABLE_PASSWORD        0xF6
#define ATA_CMD_READ_MAX_ADDRESS        0xF8
#define ATA_CMD_SET_MAX_ADDRESS         0xF9
#define ATA_CMD_SET_MAX_SET_PASSWORD    0xF9    // Features register - 0x01
#define ATA_CMD_SET_MAX_LOCK            0xF9    // Features register - 0x02
#define ATA_CMD_SET_MAX_UNLOCK          0xF9    // Features register - 0x03
#define ATA_CMD_SET_MAX_FREEZE_LOCK     0xF9    // Features register - 0x04

#define ATAPI_CMD_READ  0xA8
#define ATAPI_CMD_EJECT 0x1B

/**
 * CHECK_POWER_MODE
 **/ 
#define ATA_PM_STANDBY      0x00
#define ATA_PM_IDLE         0x80
#define ATA_PM_ACTIVE_IDLE  0xFF

#endif
