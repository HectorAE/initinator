initinator
==========

initinator is a generic initramfs building and configuration solution. It is an
alternative to initramfs build systems like
[mkinitcpio](https://wiki.archlinux.org/index.php/Mkinitcpio) or
[dracut](https://dracut.wiki.kernel.org/index.php/Main_Page). Like those, it
has a modular architecture. initinator is designed to produce an absolutely
minimal BusyBox-based, callback-driven init script for the initramfs. The
generated init script is designed to be readable and easily understandable.

Currently, initinator is in the alpha stage and has been through minimal
testing, so its use in important systems is not advised. Testing can be done
safely in a virtual machine, however, and bug reports are welcome.

Origin of the name
------------------

When I first had the idea for this project, I had a hard time coming up with a
good name. I decided to bring it up at a fall 2015 meeting of the RIT Linux
User Group, and someone immediately suggested "initinator", so it seemed like
it was meant to be. The "-inator" prefix comes from the habit of the character
Dr. Doofenshmirtz (from the recently popular animated children's television
show "Phineas and Ferb") of naming all his evil inventions in the form
_verb_-inator, no matter how ridiculous that sounded.
