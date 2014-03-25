sc_u_series_support Change Log
==============================

1.0.2
-----

  * Changes to dependencies:

    - sc_util: 1.0.3rc0 -> 1.0.4rc0

      + module_logging now compiled at -Os
      + debug_printf in module_logging uses a buffer to deliver messages unfragmented
      + Fix thread local storage calculation bug in libtrycatch
      + Fix debug_printf itoa to work for unsigned values > 0x80000000

1.0.1
-----
  * Documentation changes to reflect new repo name.

1.0.0
-----
  * Initial release
