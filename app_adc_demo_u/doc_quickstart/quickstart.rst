xCORE-USB ADC Quick Start Guide
===============================

.. _app_adc_demo_u_quick_start:

app_adc_demo_u Quick Start Guide
-----------------------------------

This application demonstrates how to use the ADC on xCORE-USB (U-Series)
devices. The demo is designed to run out of the box on the ``USB AUDIO 2.0 DJ KIT``
(XP-SKC-SU1).

The application reads the ADC and prints to the console whenever the ADC value
changes. The ADC input is connected to the potentiometer on the board.

Hardware Setup
++++++++++++++

To setup the hardware (:ref:`adc_u_example_hardware_setup`):

    #. Connect the XTAG-2 USB debug adaptor to the DJ KIT board (via the supplied adaptor board)
    #. Connect the XTAG-2 to host PC (via a USB extension cable if desired)
    #. For power, connect the USB connector on the DJ KIT board to the host PC.

.. _adc_u_example_hardware_setup:

.. figure:: images/hw_setup.*
   :width: 120mm
   :align: center

   Hardware Setup for U-Series ADC example

Import and Build the Application
++++++++++++++++++++++++++++++++

   #. Open xTIMEcomposer and open the edit perspective (Window->Open Perspective->XMOS Edit).
   #. Locate the ``xCORE-USB ADC Example`` item in the xSOFTip pane on the bottom left
      of the window and drag it into the Project Explorer window in the xTIMEcomposer.
      This will also cause the modules on which this application depends (in this case,
      module_xassert, module_logging) to be imported as well. 
   #. Click on the ``app_adc_demo_u`` item in the Explorer pane then click on the
      build icon (hammer) in xTIMEcomposer. Check the console window to verify that the
      application has built successfully.

Note that the Developer Column in the xTIMEcomposer on the right hand side of your screen
provides information on the xSOFTip components you are using. Select the module_xud
component in the Project Explorer, and you will see its description together with API
documentation. Having done this, click the `back` icon until you return to this
quickstart guide within the Developer Column.

For help in using xTIMEcomposer, try the xTIMEcomposer tutorial (See Help->Tutorials in xTIMEcomposer).

Run the Application
+++++++++++++++++++

Now that the application has been compiled, the next step is to run it on the
board using the tools to load the application over JTAG (via the XTAG-2 Adaptor card)
into the xCORE multicore microcontroller.

   #. Click on the ``Run`` icon (the white arrow in the green circle). A dialog will appear
      asking which device to connect to. Select ``XMOS XTAG2``.
   #. The application will start running and print the value of the ADC which should be
      connected to the potentiometer on the board.
   #. Turning the potentiometer will change the value the ADC is reading.

