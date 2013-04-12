In-Device Peripheral Library
============================

This module provides access to the in-device peripherals. 

Currently the library only supports the Analog to Digital Converters (ADC).

ADC API
-------

.. doxygenenum:: adc_bits_per_sample_t

.. doxygenfunction:: adc_enable
.. doxygenfunction:: adc_disable_all
.. doxygenfunction:: adc_trigger
.. doxygenfunction:: adc_trigger_packet
.. doxygenfunction:: adc_read
.. doxygenfunction:: adc_read_packet

