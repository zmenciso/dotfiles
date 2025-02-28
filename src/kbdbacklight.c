/* Original Author: Howard Chu <hyc@symas.com> 2013-01-15
 *
 * compile as "gcc -O2 -o kbdbacklight kbdbacklight.c" and run it in the background, or arrange to have it run at bootup.
 *
 * adapted by gabtub@gmail.com 2017-01-22
 * using https://gist.github.com/hadess/6847281
 * based on http://askubuntu.com/questions/383501/enable-the-keyboard-backlights-on-supported-lenovo-e-g-carbon-x1-with-command
 * original code found at  http://forum.notebookreview.com/threads/asus-keyboard-backlight-controller.703985/
 * sigterm catching done as shown in https://airtower.wordpress.com/2010/06/16/catch-sigterm-exit-gracefully/
 *
 * fixed by sva 2022-10-08
 * refactored the whole code out of boredom. keyboard should now be detected automatically using libudev.h 2023-06-25
 * uses /sys/class/leds/, s.t. ec_sys is not necessary
 *
 * monitor keyboard activity and toggle keyboard backlight
 */
#include <stdio.h> // fprintf(), snprintf(), stderr
#include <unistd.h> // write(), close(), read()
#include <string.h> // strlen(), strncpy()
#include <fcntl.h> // open(), O_RDONLY, O_WRONLY
#include <limits.h> // PATH_MAX
#include <poll.h> // poll()

#include <linux/input.h> // struct input_event, EV_KEY
#include <libudev.h> // udev stuff

#define IDLE_MSEC 4000
#define BRGHT_OFF 0
#define BRGHT_MED 128
#define BRGHT_HI 255

static volatile int running = 1;

static int find_keyboard(char* devnode, size_t size) {
  struct udev* udev = udev_new();
  if (!udev) {
    fprintf(stderr, "Failed to create udev context\n");
    return -1;
  }

  struct udev_enumerate* enumerate = udev_enumerate_new(udev);
  if (!enumerate) {
    fprintf(stderr, "Failed to create udev enumerate\n");
    udev_unref(udev);
    return -1;
  }

  udev_enumerate_add_match_subsystem(enumerate, "input");
  udev_enumerate_add_match_property(enumerate, "ID_INPUT_KEYBOARD", "1");
  udev_enumerate_scan_devices(enumerate);

  struct udev_list_entry* devices = udev_enumerate_get_list_entry(enumerate);
  struct udev_list_entry* entry;
  int found = 0;

  udev_list_entry_foreach(entry, devices) {
    const char* path = udev_list_entry_get_name(entry);
    struct udev_device* dev = udev_device_new_from_syspath(udev, path);
    if (!dev) {
      fprintf(stderr, "Failed to create udev device\n");
      continue;
    }

    const char* devnode_path = udev_device_get_devnode(dev);
    if (devnode_path) {
      if (strlen(devnode_path) < size) {
        strncpy(devnode, devnode_path, size);
        found = 1;
        break;
      } else {
        fprintf(stderr, "Device node path is too long\n");
      }
    }

    udev_device_unref(dev);
  }

  udev_enumerate_unref(enumerate);
  udev_unref(udev);

  return found ? 0 : -1;
}

static int set_backlight(int brightness) {
  char buf[16];
  snprintf(buf, sizeof(buf), "%d", brightness);
  int fd = open("/sys/class/leds/tpacpi::kbd_backlight/brightness", O_WRONLY);
  if (fd < 0) {
    fprintf(stderr, "Failed to open keyboard backlight file\n");
    return -1;
  }
  if (write(fd, buf, strlen(buf)) != strlen(buf)) {
    fprintf(stderr, "Failed to set keyboard backlight\n");
    close(fd);
    return -1;
  }
  close(fd);
  return 0;
}

static void handle_input(int fd, int* brightness) {
  struct input_event ev;
  int rc = read(fd, &ev, sizeof(ev));
  if (rc > 0) {
    if (ev.type == EV_KEY && ev.value == 1) {
      set_backlight(BRGHT_HI);
      *brightness = BRGHT_HI;
    }
  }
}

static void handle_timeout(int fd, int* brightness) {
  set_backlight(BRGHT_OFF);
  *brightness = BRGHT_OFF;
}

static void handle_poll(int fd, int* brightness) {
  struct pollfd pfd;
  pfd.fd = fd;
  pfd.events = POLLIN;
  int timeout = IDLE_MSEC;
  while (running) {
    int rc = poll(&pfd, 1, timeout);
    if (rc > 0) {
      handle_input(fd, brightness);
      timeout = IDLE_MSEC;
    } else if (rc == 0) {
      handle_timeout(fd, brightness);
      timeout = -1;
    }
  }
}

int main(int argc, char** argv) {
  char devnode[PATH_MAX];
  if (find_keyboard(devnode, sizeof(devnode)) < 0) {
    fprintf(stderr, "Failed to find keyboard device\n");
    return 1;
  }

  int fd = open(devnode, O_RDONLY);
  if (fd < 0) {
    fprintf(stderr, "Failed to open keyboard device\n");
    return 1;
  }

  int brightness = BRGHT_OFF;
  set_backlight(brightness);
  handle_poll(fd, &brightness);
  close(fd);
  return 0;
}
