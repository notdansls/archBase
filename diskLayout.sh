# Stolen from https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
#     Thank you user2070305
# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $storage
  g # Create a new empty GPT partition table
  n # new partition
  1 # default - partition 1
    # default - start at beginning of disk 
  +1M # 1M boot partition
  t # Change the partition type
  4 # Change the type to BIOS Boot
  n # new partition
  2 # default - partition 2
    # default - first free sector
    # default - extend partition to end of disk
  w # write the partition table
EOF
